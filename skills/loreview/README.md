# Loreview

**Review AI-written pull requests by building the understanding you would gain from writing the code yourself.**

Loreview turns a pull request into a reviewer-led investigation. It surfaces the consequential parts of a change, lets you choose what to explore, and follows the source, tests, and behavior until you can make your own engineering judgment.

```text
PR #289 · 8b1f4e2 · about 12 minutes

1. Failure reporting — What reaches the user after the final build retry?
2. Platform verification — What happens when an artifact targets another OS?
3. Request ownership — Which request receives a delayed worker result?

Where would you like to start?
```

Ask to inspect the implementation, trace a scenario, predict an outcome, or reconstruct a small part yourself. The path belongs to you.

## Try it

```text
$loreview PR 289
$loreview this branch
$loreview these uncommitted changes
```

Loreview pins the exact reviewed revision and keeps session state beneath the repository's shared Git directory. Predictions and confidence are not recorded by default. Source changes, test execution, public comments, and review submission require your approval.

## Check the session helper

```text
python3 tests/test_session.py
```

Run that command from this skill's directory.
