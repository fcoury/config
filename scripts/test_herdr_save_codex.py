"""Behavior checks for the external Herdr/Codex session repair tool."""

import contextlib
import importlib.machinery
import importlib.util
import io
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch


loader = importlib.machinery.SourceFileLoader("herdr_save_codex", str(Path(__file__).with_name("herdr-codex")))
spec = importlib.util.spec_from_loader(loader.name, loader)
tool = importlib.util.module_from_spec(spec)
loader.exec_module(tool)

ROOT = "01a18083-4713-79d0-90db-bfcb959662fc"
CHILD = "01a1808c-5088-7593-bc50-ad800bfea701"


class SessionRepairTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.home = Path(temporary.name)
        self.codex = self.home / ".codex"

    def rollout(self, session_id=ROOT, source="cli", home=None):
        path = (home or self.codex) / "sessions" / f"rollout-{session_id}.jsonl"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps({"type": "session_meta", "payload": {"id": session_id, "source": source}}) + "\n")
        return path

    def test_subagent_is_not_selected_even_when_newer(self):
        child = self.rollout(CHILD, {"subagent": {"thread_spawn": {"parent_thread_id": ROOT}}})
        self.assertEqual(tool.identify([child, self.rollout()], self.codex), ROOT)

    def test_ambiguous_or_missing_main_is_not_guessed(self):
        for paths in ([], [self.rollout(), self.rollout(CHILD)]):
            with self.assertRaisesRegex(ValueError, "cannot choose safely"):
                tool.identify(paths, self.codex)

    def test_deleted_file_and_custom_home_are_unresolved(self):
        with self.assertRaisesRegex(ValueError, "missing on disk"):
            tool.identify([self.codex / "sessions" / "rollout-deleted.jsonl"], self.codex)
        with self.assertRaisesRegex(ValueError, "custom CODEX_HOME"):
            tool.identify([self.rollout(home=self.home / "custom")], self.codex)

    def exercise(self, *, check=False, racing=False, persist=True, live_matches=False):
        session_file = self.home / "session.json"
        stored = {"workspaces": [{"id": "w1", "public_pane_numbers": {"123": 55},
                  "tabs": [{"panes": {"123": {"agent_session": tool.reference(CHILD)}}}]}]}
        session_file.write_text(json.dumps(stored))
        agent = {"pane_id": "w1:p1Q", "agent": "codex",
                 "agent_session": tool.reference(ROOT if live_matches else CHILD)}
        reports = []
        reads = 0

        def fake_herdr(session, *args):
            nonlocal reads
            self.assertEqual(session, "default")
            if args == ("api", "snapshot"):
                return {"result": {"snapshot": {"agents": [agent.copy()]}}}
            if args[:2] == ("pane", "process-info"):
                reads += 1
                return {"result": {"process_info": {"foreground_processes": [
                    {"name": "codex", "pid": 11 if reads == 1 or not racing else 22}]}}}
            if args[:2] == ("pane", "report-agent-session"):
                reports.append(args)
                agent["agent_session"] = tool.reference(args[args.index("--agent-session-id") + 1])
                if persist:
                    stored["workspaces"][0]["tabs"][0]["panes"]["123"]["agent_session"] = agent["agent_session"]
                    session_file.write_text(json.dumps(stored))
                return None
            if args[:2] == ("agent", "get"):
                return {"result": {"agent": agent}}
            self.fail(args)

        sessions = json.dumps({"sessions": [{"name": "default", "running": True, "session_dir": str(self.home)}]})
        output = io.StringIO()
        with patch.object(tool, "herdr", side_effect=fake_herdr), \
             patch.object(tool, "run", return_value=sessions), \
             patch.object(tool, "open_rollouts", return_value=[self.rollout()]), \
             patch.object(tool.Path, "home", return_value=self.home), \
             patch.object(tool.shutil, "which", return_value="/bin/fake"), \
             patch.object(tool.time, "monotonic", side_effect=[0, 20]), \
             patch("sys.argv", ["herdr-save-codex"] + (["--check"] if check else [])), \
             contextlib.redirect_stdout(output):
            result = tool.main()
        return result, reports, output.getvalue(), session_file

    def test_stale_reference_is_repaired_backed_up_and_verified_on_disk(self):
        result, reports, output, session_file = self.exercise()
        self.assertEqual(result, 0)
        self.assertEqual(len(reports), 1)
        self.assertIn("--seq", reports[0])
        self.assertEqual(tool.saved_references(session_file)["w1:p1Q"], tool.reference(ROOT))
        backups = list((self.home / ".cache").rglob("session.before.json"))
        self.assertEqual(len(backups), 1)
        self.assertEqual(tool.saved_references(backups[0])["w1:p1Q"], tool.reference(CHILD))
        self.assertIn("1/1 Codex panes verified on disk", output)

    def test_check_does_not_report_or_create_backup(self):
        result, reports, output, session_file = self.exercise(check=True)
        self.assertEqual(result, 1)
        self.assertEqual(reports, [])
        self.assertFalse((self.home / ".cache").exists())
        self.assertEqual(tool.saved_references(session_file)["w1:p1Q"], tool.reference(CHILD))

    def test_changed_process_is_not_updated(self):
        result, reports, output, _ = self.exercise(racing=True)
        self.assertEqual(result, 1)
        self.assertEqual(reports, [])
        self.assertIn("conversation changed", output)

    def test_api_acceptance_without_disk_save_is_failure(self):
        result, reports, output, _ = self.exercise(persist=False)
        self.assertEqual(result, 1)
        self.assertIn("NOT SAVED on disk", output)

    def test_disk_drift_is_repaired_even_when_live_reference_matches(self):
        result, reports, output, session_file = self.exercise(live_matches=True)
        self.assertEqual(result, 0)
        self.assertEqual(len(reports), 1)
        self.assertEqual(tool.saved_references(session_file)["w1:p1Q"], tool.reference(ROOT))

    def test_ready_shell_rejects_downloaders_and_prompt_drafts(self):
        info = {"shell_pid": 10, "foreground_processes": [{"pid": 10, "name": "fish"}]}
        with patch.object(tool, "process_info", return_value=info), patch.object(tool, "run") as read:
            for text, expected in [("downloading...\n", None), ("> $ codex res", None),
                                   ("> $\n", 10), ("error\n\n> $\n\n", 10)]:
                read.return_value = text
                self.assertEqual(tool.ready_shell("default", "w1:p1"), expected)
            info["foreground_processes"].append({"pid": 11, "name": "python3"})
            self.assertIsNone(tool.ready_shell("default", "w1:p1"))

    def exercise_restore(self, *, dry_run=False, ready=True, busy=False, existing=None,
                         verify=True, changed=False, missing=False, startup=False):
        pane = {"pane_id": "w1:p1", "terminal_id": "term1", "agent_session": tool.reference(ROOT)}
        shell = {"shell_pid": 10, "foreground_processes": [{"pid": 10, "name": "fish"}]}
        if busy:
            shell["foreground_processes"] = [{"pid": 20, "name": "vim"}]
        if startup:
            shell["foreground_processes"].append({"pid": 11, "name": "python3"})
        if existing:
            shell["foreground_processes"] = [{"pid": 20, "name": "codex"}]
        calls = []

        def fake_herdr(session, *args):
            calls.append(args)
            if args[:2] == ("pane", "get"):
                return {"result": {"pane": dict(pane, terminal_id="changed" if changed else "term1")}}
            if args[:2] == ("pane", "run"):
                self.assertEqual(args, ("pane", "run", "w1:p1", "codex resume " + ROOT))
                return {}
            self.fail(args)

        args = SimpleNamespace(session="default", wait=1, dry_run=dry_run)
        output = io.StringIO()
        with patch.object(tool, "process_info", return_value=shell), \
             patch.object(tool, "rollout_exists", return_value=not missing), \
             patch.object(tool, "ready_shell", side_effect=[None, 10, 10] if startup else None,
                          return_value=10 if ready else None), \
             patch.object(tool.time, "sleep"), \
             patch.object(tool, "herdr", side_effect=fake_herdr), \
             patch.object(tool, "identify", return_value=existing), \
             patch.object(tool, "open_rollouts", return_value=[]), \
             patch.object(tool, "wait_restored", side_effect=None if verify else ValueError("not verified")) as wait, \
             contextlib.redirect_stdout(output):
            result = tool.restore(args, {"w1:p1": tool.reference(ROOT)}, {"panes": [pane]})
        return result, [c for c in calls if c[:2] == ("pane", "run")], output.getvalue(), wait.call_count

    def test_restore_waits_for_exact_session_verification(self):
        result, sends, output, checks = self.exercise_restore()
        self.assertEqual((result, len(sends), checks), (0, 1, 1))
        self.assertIn("RESTORED", output)

    def test_restore_preview_does_not_send(self):
        result, sends, output, checks = self.exercise_restore(dry_run=True)
        self.assertEqual((result, sends, checks), (0, [], 0))
        self.assertIn("WOULD RESTORE", output)

    def test_restore_does_not_send_to_unready_or_busy_or_changed_panes(self):
        for options in ({"ready": False, "dry_run": True}, {"busy": True},
                        {"changed": True}, {"missing": True}):
            with self.subTest(options=options):
                result, sends, _, checks = self.exercise_restore(**options)
                self.assertEqual((result, sends, checks), (1, [], 0))

    def test_restore_skips_existing_and_rejects_wrong_conversation(self):
        result, sends, output, _ = self.exercise_restore(existing=ROOT)
        self.assertEqual((result, sends), (0, []))
        self.assertIn("RUNNING", output)
        result, sends, output, _ = self.exercise_restore(existing=CHILD)
        self.assertEqual((result, sends), (1, []))
        self.assertIn("another conversation", output)

    def test_restore_never_retries_unverified_submission(self):
        result, sends, _, checks = self.exercise_restore(verify=False)
        self.assertEqual((result, len(sends), checks), (1, 1, 1))

    def test_restore_waits_for_startup_downloader_to_finish(self):
        result, sends, output, checks = self.exercise_restore(startup=True)
        self.assertEqual((result, len(sends), checks), (0, 1, 1))

    def test_restore_rejects_noncanonical_duplicate_session_id(self):
        with patch.object(tool, "process_info", side_effect=ValueError("blocked")), \
             contextlib.redirect_stdout(io.StringIO()) as output:
            refs = {"w1:p1": tool.reference(ROOT), "w2:p2": tool.reference(ROOT.upper())}
            result = tool.restore(SimpleNamespace(session="default", wait=1, dry_run=False),
                                  refs, {"panes": [{"pane_id": "w1:p1"}, {"pane_id": "w2:p2"}]})
        self.assertEqual(result, 1)
        self.assertIn("canonical UUID", output.getvalue())

    def test_restore_submits_all_ready_panes_before_verifying_startup(self):
        refs = {"w1:p1": tool.reference(ROOT), "w2:p2": tool.reference(CHILD)}
        panes = [{"pane_id": key, "terminal_id": key, "agent_session": ref} for key, ref in refs.items()]
        shell = {"shell_pid": 10, "foreground_processes": [{"pid": 10, "name": "fish"}]}
        sent = []
        def api(session, *args):
            if args[:2] == ("pane", "get"):
                return {"result": {"pane": next(p for p in panes if p["pane_id"] == args[2])}}
            sent.append(args[2])
        def verify(*args):
            self.assertEqual(sent, ["w1:p1", "w2:p2"])
        with patch.object(tool, "process_info", return_value=shell), \
             patch.object(tool, "rollout_exists", return_value=True), \
             patch.object(tool, "ready_shell", return_value=10), \
             patch.object(tool, "herdr", side_effect=api), \
             patch.object(tool, "wait_restored", side_effect=verify), \
             contextlib.redirect_stdout(io.StringIO()):
            result = tool.restore(SimpleNamespace(session="default", wait=1, dry_run=False), refs, {"panes": panes})
        self.assertEqual(result, 0)

    def test_restore_rejects_duplicate_ids_before_sending(self):
        output = io.StringIO()
        with patch.object(tool, "herdr") as api, contextlib.redirect_stdout(output):
            result = tool.restore(SimpleNamespace(session="default", wait=1, dry_run=False),
                                  {"w1:p1": tool.reference(ROOT), "w2:p2": tool.reference(ROOT)},
                                  {"panes": []})
        self.assertEqual(result, 1)
        api.assert_not_called()
        self.assertIn("multiple panes", output.getvalue())


if __name__ == "__main__":
    unittest.main()
