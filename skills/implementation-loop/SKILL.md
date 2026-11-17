---
name: implementation-loop
description: Run the Implementation Loop for an approved Agent Brief: start fresh implement and review sessions round by round until the human is needed.
disable-model-invocation: true
argument-hint: "<issue#>"
---

# Implementation Loop

You are the conductor for brief #<issue>. You start each stage in a fresh, named background session and route by its result. Stay thin: never read code, diffs, or the sessions' conversations. Your only inputs are GitHub's state and the one-line results sessions write to the results file.

## Before you start

- Read `~/.claude/basecamp/practices.md`, all of it. Anything you post is signed `Orchestrator`, per its Writing section.
- Your first output to the human is:
  > Name this session: `/rename <repo> · conductor`
- The **results file** for this brief is `$TMPDIR/implementation-loop/<repo>-<issue#>.log`. Create it if it doesn't exist. Stage sessions append one line to it when they finish.

## Steps

1. **Work out where things stand** from GitHub. Keep no state of your own.
   - Read the brief issue. Find its PR: branch `brief/<issue#>-*`, with `Closes #<issue#>`, and not from a fork (`isCrossRepository` false). Ignore any other PR, even one that matches the branch name.
   - Everything below reads only **trusted posts**, as the pr-review skill's `SKILL.md` (in the `pr-review` folder next to this skill's folder) defines them. A review, Human Decision, answer, or Human Brief from any other author doesn't count.
   - **No PR:** next is implement, round 1.
   - **A trusted Human Brief is posted:** the loop is finished. Report and stop.
   - **An open Human Decision with no answer yet:** stop and tell the human what's waiting. Answers are recorded where step 7 (Route) of the pr-review skill's `SKILL.md` (in the `pr-review` folder next to this skill's folder) says, and only the ones it says count are answers: look for them there.
   - **Commits newer than the latest review summary** (the `PR Review · round <n>` post that holds a rulings table), or no review yet: next is review, same round.
   - **The latest review accepted findings, or a Human Decision was answered:** next is implement, round n+1.

2. **Prepare the worktree.** Make sure `.claude/worktrees/<issue#>` exists on branch `brief/<issue#>-<slug>`, created from `main` if it doesn't. Every stage session runs there.

3. **Start the stage** as a background session in the worktree, in `auto` permission mode, named `<repo> #<issue#> · <stage> · r<round>`:
   - **implement:** tell it to read and follow `implement.md` from this skill's own folder (give it the full path) for issue #<issue#>, round <round>, reporting to the results file.
   - **review:** `/pr-review <PR#> --report-to <results file>`.

4. **Wait for its line in the results file.** While waiting, check the session's state in `claude agents --json`. If it shows it's waiting for input, tell the human:
   > Session `<name>` is waiting for you: run `claude attach <name>`.

5. **Clean up.** Once a session reports, remove it, unless it's a review session that escalated. That one stays open so the human can talk it through.

6. **Route.**
   - **implement done:** start review, same round.
   - **implement blocked:** stop. The human is needed.
   - **review accepted findings:** start implement, next round.
   - **review escalated, or done:** stop.
   - **review refused:** stop and tell the human why. The PR you found is from a fork, which step 1 should have ruled out.

7. **When you stop,** give the human a short status:
   - one line per round so far, from the results file
   - why you stopped
   - the PR link

   To resume after answering a Human Decision, the human says "resume" here, or runs `/implementation-loop <issue#>` again.
