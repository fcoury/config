#!/usr/bin/env python3
"""Run isolated regression checks for git diffstat."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest
import uuid


SCRIPT = Path(__file__).resolve().with_name("git-diffstat")


class DiffstatTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="diffstat-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
        self.env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1")
        self.git("init", "-b", "main")
        self.git("config", "user.name", "Diffstat Test")
        self.git("config", "user.email", "diffstat@example.invalid")
        self.write("tracked", "original\n")
        self.write("removed", "remove me\n")
        self.write(".gitignore", "ignored*\n")
        self.git("add", ".")
        self.git("commit", "-m", "initial")
        self.git("switch", "-c", "fcoury/feature")

    def git(self, *args, cwd=None):
        return subprocess.check_output(
            ["git", *args], cwd=cwd or self.root, env=self.env, stderr=subprocess.PIPE,
        )

    def write(self, name, content):
        (self.root / name).write_text(content)

    def run_stat(self, *args, cwd=None, ok=True):
        index = self.git("rev-parse", "--path-format=absolute", "--git-path", "index", cwd=cwd).decode().strip()
        before = Path(index).read_bytes()
        objects = self.git("count-objects", "-v")
        result = subprocess.run(
            [str(SCRIPT), *args], cwd=cwd or self.root, env=self.env,
            capture_output=True, text=True,
        )
        self.assertEqual(Path(index).read_bytes(), before, "real staging area changed")
        self.assertEqual(self.git("count-objects", "-v"), objects, "snapshot objects leaked")
        self.assertEqual(result.returncode == 0, ok, result.stderr)
        return result.stdout if ok else result.stderr

    def test_mixed_changes_and_subdirectory(self):
        self.write("tracked", "original\ncommitted\n")
        self.git("commit", "-am", "committed")
        self.write("tracked", "original\ncommitted\nstaged\n")
        self.git("add", "tracked")
        self.write("tracked", "original\ncommitted\nstaged\npending\n")
        self.write("new\tfile\nname", "new\nsecond\n")
        self.write("ignored-file", "ignored\n")
        (self.root / "removed").unlink()
        (self.root / "nested").mkdir()
        output = self.run_stat("--stat", cwd=self.root / "nested")
        self.assertIn("+5 -1 · 3 files", output)
        self.assertIn("tracked", output)

    def test_changes_cancel_and_clean_is_explicit(self):
        self.write("tracked", "original\ncommitted\n")
        self.git("commit", "-am", "committed")
        self.write("tracked", "original\n")
        self.assertIn("+0 -0 · 0 files", self.run_stat())

    def test_binary_rename_and_staged_ignored_file(self):
        self.git("mv", "tracked", "renamed")
        (self.root / "binary").write_bytes(b"\0binary\n")
        self.write("ignored-forced", "included\n")
        self.git("add", "-f", "ignored-forced")
        self.assertIn("+1 -0 · 3 files · 1 binary", self.run_stat())

    def test_base_precedence_and_divergence(self):
        self.git("switch", "main")
        self.write("base-only", "not our change\n")
        self.git("add", ".")
        self.git("commit", "-m", "base advances")
        self.git("switch", "fcoury/feature")
        self.assertIn("+0 -0 · 0 files", self.run_stat())
        self.git("branch", "master")
        self.assertIn("--base", self.run_stat(ok=False))
        self.git("config", "diffstat.base", "master")
        self.assertIn("base master", self.run_stat())
        self.assertIn("base main", self.run_stat("--base", "main"))
        self.git("config", "--unset", "diffstat.base")
        self.git("update-ref", "refs/remotes/origin/main", "main")
        self.git("symbolic-ref", "refs/remotes/origin/HEAD", "refs/remotes/origin/main")
        self.assertIn("base origin/main", self.run_stat())

    def test_detached_and_invalid_base(self):
        self.git("switch", "--detach")
        self.assertIn("detached@", self.run_stat())
        self.run_stat("--base", "missing", ok=False)

    def test_split_index(self):
        self.git("update-index", "--split-index")
        self.write("new", "new\n")
        self.assertIn("+1 -0 · 1 file", self.run_stat())

    def test_fish_shorthand(self):
        env = self.env | {"PATH": str(SCRIPT.parent) + os.pathsep + self.env["PATH"]}
        function = SCRIPT.parent.parent / "fish/functions/gd.fish"
        for args, expected in ((["--base", "main", "--stat"], "+0 -0 · 0 files"), (["--help"], "--base REF")):
            output = subprocess.check_output(
                ["fish", "--no-config", "-c", 'source "$argv[1]"; gd $argv[2..-1]',
                 str(function), *args], cwd=self.root, env=env, text=True,
            )
            self.assertIn(expected, output)

    def test_merge_conflict(self):
        self.write("tracked", "feature\n")
        self.git("commit", "-am", "feature")
        self.git("switch", "main")
        self.write("tracked", "main\n")
        self.git("commit", "-am", "main")
        self.git("switch", "fcoury/feature")
        with self.assertRaises(subprocess.CalledProcessError):
            self.git("merge", "main")
        self.assertIn("Resolve merge conflicts", self.run_stat(ok=False))

    def test_linked_worktree(self):
        # Worktrees live beside the config checkout, never under /tmp.
        worktree = SCRIPT.parent.parent.parent / ("config.fcoury-diffstat-test-" + uuid.uuid4().hex)
        self.git("worktree", "add", "--detach", str(worktree), "HEAD")
        self.addCleanup(self.git, "worktree", "remove", "--force", str(worktree))
        (worktree / "local").write_text("linked worktree\n")
        self.assertIn("+1 -0 · 1 file", self.run_stat(cwd=worktree))
        self.assertIn("+0 -0 · 0 files", self.run_stat())


if __name__ == "__main__":
    unittest.main()
