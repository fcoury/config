#!/usr/bin/env python3
"""Focused end-to-end checks for Loreview's private session helper."""

from __future__ import annotations

import json
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "session.py"


class SessionHelperTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory(prefix="loreview-test-")
        self.repository = Path(self.temporary.name) / "repository"
        self.repository.mkdir()
        self.git("init", "--quiet", "--initial-branch=main")
        self.git("config", "user.name", "Loreview Test")
        self.git("config", "user.email", "loreview-test@example.invalid")
        self.path = self.repository / "worker.py"
        self.path.write_text("def report():\n    return 'ready'\n", encoding="utf-8")
        self.commit("initial worker")
        self.base = self.git("rev-parse", "HEAD")
        self.git("checkout", "--quiet", "-b", "review")
        self.path.write_text("def report():\n    return 'timeout'\n", encoding="utf-8")
        self.commit("report retry exhaustion")
        self.head = self.git("rev-parse", "HEAD")

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def git(self, *arguments: str) -> str:
        result = subprocess.run(
            ["git", "-C", str(self.repository), *arguments],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
        return result.stdout.strip()

    def commit(self, message: str) -> None:
        self.git("add", "worker.py")
        self.git("commit", "--quiet", "-m", message)

    def run_helper(self, *arguments: str, expected_status: int = 0) -> dict:
        result = subprocess.run(
            [sys.executable, os.fsdecode(SCRIPT), *arguments],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        self.assertEqual(
            result.returncode,
            expected_status,
            msg=f"stdout: {result.stdout}\nstderr: {result.stderr}",
        )
        output = result.stdout if expected_status in (0, 2) else result.stderr
        return json.loads(output)

    def initialize(self, *extra: str) -> dict:
        return self.run_helper(
            "init",
            "--repo",
            str(self.repository),
            "--session",
            "pr-289",
            "--base",
            "main",
            "--head",
            "HEAD",
            *extra,
        )

    def test_committed_session_is_pinned_and_private(self) -> None:
        session = self.initialize("--source", "PR #289")
        directory = Path(session["session_dir"])
        metadata = directory / "session.json"

        self.assertEqual(session["snapshot"]["base_sha"], self.base)
        self.assertEqual(session["snapshot"]["head_sha"], self.head)
        self.assertEqual(session["snapshot"]["merge_base_sha"], self.base)
        self.assertEqual(len(session["snapshot"]["patch_sha256"]), 64)
        self.assertFalse(session["research_opt_in"])
        self.assertEqual(directory.parent, (self.repository / ".git" / "loreview").resolve())
        self.assertEqual(stat.S_IMODE(directory.parent.stat().st_mode), 0o700)
        self.assertEqual(stat.S_IMODE(directory.stat().st_mode), 0o700)
        self.assertEqual(stat.S_IMODE(metadata.stat().st_mode), 0o600)
        self.assertEqual(self.git("status", "--porcelain"), "")
        self.assertFalse((directory / "target.diff").exists())
        self.assertFalse((directory / "events.jsonl").exists())

    def test_initializing_the_same_snapshot_resumes(self) -> None:
        first = self.initialize()
        second = self.initialize()
        self.assertFalse(first["resumed"])
        self.assertTrue(second["resumed"])
        self.assertEqual(first["session_id"], second["session_id"])

    def test_branch_changes_invalidate_the_session(self) -> None:
        session = self.initialize()
        self.path.write_text("def report():\n    return 'build failed'\n", encoding="utf-8")
        self.commit("preserve original error")

        result = self.run_helper(
            "verify",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            expected_status=2,
        )

        self.assertFalse(result["ok"])
        self.assertIn("checkout_head_changed", result["reasons"])
        self.assertIn("review_head_changed", result["reasons"])

    def test_worktree_session_names_excluded_untracked_files_and_detects_drift(self) -> None:
        self.path.write_text("def report():\n    return 'not yet committed'\n", encoding="utf-8")
        (self.repository / "scratch.txt").write_text("private scratch", encoding="utf-8")

        session = self.run_helper(
            "init",
            "--repo",
            str(self.repository),
            "--session",
            "local-change",
            "--worktree",
        )
        self.assertEqual(session["snapshot"]["kind"], "worktree")
        self.assertEqual(session["snapshot"]["excluded_untracked_paths"], ["scratch.txt"])

        self.path.write_text("def report():\n    return 'changed again'\n", encoding="utf-8")
        result = self.run_helper(
            "verify",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            expected_status=2,
        )
        self.assertIn("working_tree_patch_changed", result["reasons"])

    def test_findings_are_private_source_pinned_and_reject_stale_snapshots(self) -> None:
        session = self.initialize()
        finding = self.run_helper(
            "finding",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            "--title",
            "Retry exhaustion loses the original error",
            "--anchor",
            "worker.py:2",
            "--evidence-kind",
            "source-grounded",
            "--detail",
            "The final attempt reports a timeout instead of the worker error.",
        )
        findings_path = Path(session["session_dir"]) / "findings.json"

        self.assertTrue(finding["saved"])
        self.assertEqual(finding["finding"]["review_head_sha"], self.head)
        self.assertEqual(stat.S_IMODE(findings_path.stat().st_mode), 0o600)
        self.assertEqual(self.git("status", "--porcelain"), "")

        self.path.write_text("def report():\n    return 'build failed'\n", encoding="utf-8")
        self.commit("fix reporting")
        stale = self.run_helper(
            "finding",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            "--title",
            "Another concern",
            "--anchor",
            "worker.py:2",
            "--evidence-kind",
            "inferred",
            "--detail",
            "The revision has already changed.",
            expected_status=1,
        )
        self.assertIn("snapshot changed", stale["error"])

    def test_telemetry_requires_explicit_research_consent(self) -> None:
        session = self.initialize()
        rejected = self.run_helper(
            "event",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            "--kind",
            "prediction",
            "--data",
            '{"answer":"private"}',
            expected_status=1,
        )
        self.assertIn("explicit consent", rejected["error"])
        self.assertFalse((Path(session["session_dir"]) / "events.jsonl").exists())

        consented = self.run_helper(
            "init",
            "--repo",
            str(self.repository),
            "--session",
            "consented-study",
            "--base",
            "main",
            "--head",
            "HEAD",
            "--research-consent",
        )
        recorded = self.run_helper(
            "event",
            "--repo",
            str(self.repository),
            "--session",
            consented["session_id"],
            "--kind",
            "investigation_started",
            "--data",
            '{"area":"failure reporting"}',
        )
        events_path = Path(consented["session_dir"]) / "events.jsonl"

        self.assertTrue(recorded["recorded"])
        self.assertEqual(stat.S_IMODE(events_path.stat().st_mode), 0o600)
        self.assertEqual(json.loads(events_path.read_text())["kind"], "investigation_started")

    def test_rejects_path_traversal_in_session_names(self) -> None:
        result = self.run_helper(
            "init",
            "--repo",
            str(self.repository),
            "--session",
            "../../escape",
            "--base",
            "main",
            "--head",
            "HEAD",
            expected_status=1,
        )
        self.assertIn("session names", result["error"])

    def test_finishing_prevents_additional_findings(self) -> None:
        session = self.initialize()
        finished = self.run_helper(
            "finish",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
        )
        self.assertTrue(finished["completed"])

        rejected = self.run_helper(
            "finding",
            "--repo",
            str(self.repository),
            "--session",
            session["session_id"],
            "--title",
            "Too late",
            "--anchor",
            "worker.py:2",
            "--evidence-kind",
            "hypothetical",
            "--detail",
            "The session is complete.",
            expected_status=1,
        )
        self.assertIn("completed session", rejected["error"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
