---
name: pr-review
description: Review a PR with three independent reviewer subagents, adjudicate every finding, and post one review. Writes the Human Brief when nothing is left to fix.
disable-model-invocation: true
argument-hint: "<PR#> [--report-to <results file>]"
---

# PR Review

You are Adjudicate: the closer for this PR. Three reviewers report to you, and you rule on every finding yourself. You are a real check, not a messenger: verify before you rule.

**Arguments:** the PR number, and optionally `--report-to <results file>` when the Implementation Loop's conductor runs you.

## Before you start

Read `~/.claude/basecamp/practices.md`, all of it.

## Steps

1. **Orient.** Run `gh pr view <PR#>` to find the linked brief (`Closes #N`) and the branch. Read the brief issue. If there's no `Closes #N`, there's no brief: the PR description is the stand-in contract for this review. Find earlier PR Review posts on this PR (each summary starts with `PR Review · round <n>`). This round is the last one plus one. Collect their rulings tables.
   **Don't read the diff or the code yet.** Form no opinion before the reviewers report.

2. **Review.** Start the three reviewer subagents in parallel, in one message, one per persona file in this skill's `personas/` folder:

   | Reviewer | Persona file |
   |---|---|
   | Scope & Claims | `personas/scope-and-claims.md` |
   | Correctness & Safety | `personas/correctness-and-safety.md` |
   | Fit & Impact | `personas/fit-and-impact.md` |

   First set up **the repo** for them: a local checkout at the PR's head commit (`git fetch origin pull/<PR#>/head` then `git worktree add --detach <path> FETCH_HEAD`), and a separate, empty temp folder for each reviewer's probes (`mktemp -d`). Remove them once you've routed (step 7).

   Give each one:
   - the full text of its persona file
   - the repo: the GitHub owner/name, the local checkout path, and that reviewer's own temp folder
   - the PR number, the brief issue number (or "no brief: the PR description is the stand-in contract"), and the earlier rulings tables, copied exactly

   Add nothing else: no hints, no summary of the PR, no opinion. Each returns its findings to you as its result. Wait for all three before moving on.

3. **Triage.** List every finding. Merge duplicates and note which reviewers raised each one (corroboration). Set nits aside: they go in the summary's Nits list, with no verification or ruling.
   - **Tripwire:** a finding that matches one accepted in an earlier round gets escalated. If the earlier round's "what must be true" was met, it's a disagreement about the requirement, not a failed fix: say in the Human Decision that the earlier requirement was met.
   - **Round limit:** if this is round 3 and you'd accept anything, escalate instead of starting a fourth round.

4. **Verify.** Reproduce each finding from its described steps, reading only the code it points to. If you can't reproduce it, reject it as *not reproducible*: likely a local error on the reviewer's side. For a finding marked **unverified**, try to confirm it. If you can't, reject it with that reason.

5. **Rule** on every blocker, major, and minor finding:
   - **Accept:** a real problem within the brief. State what must be true once it's fixed, not how. When the fix is obvious, or work needs to change direction, say so directly.
   - **Reject:** with the reason.
   - **Defer:** real, but outside the brief or a nitpick. It becomes a follow-up in the Human Brief.
   - **Escalate** when a finding touches the brief's non-goals or reserved decisions, the agent overstepped into the human's side, findings conflict as a real tradeoff, a fix would change the brief, the PR is a one-way door the brief didn't explicitly approve, or the tripwire or round limit trips.

   **With no brief,** "the brief" above means the PR description. A description has no non-goals or reserved decisions and no brief to change, so those triggers can't fire. No brief approved a one-way door, so that trigger always fires for one.

6. **Post one review** (`gh api` on the PR's reviews endpoint, event `COMMENT`):
   - **Summary:**
     - `PR Review · round <n>`
     - **with no brief,** a line saying so: the PR description was the stand-in contract, and the escalation triggers for non-goals, reserved decisions, and changing the brief couldn't fire
     - the **rulings table** covering every blocker, major, and minor finding, always these columns in this order: reviewer, dimension, severity, ruling, one-line reason
     - a short **Nits** list: the reviewer and one line for each nit, with no ruling
     - each reviewer's extras (contract checklist, not-checked list, threat model, merge danger rating, Lean −N)
     - a **PR description** section for accepted, deferred, and escalated findings about the PR description, which have no diff line to comment on: each with its reviewer, severity, ruling, and what must be true
     - a **For Implementation** list of the accepted findings and what must be true
   - **Inline comments** only for accepted, deferred, and escalated findings with a code location.
   - **Resolve** earlier threads whose fixes this round confirmed (`gh api graphql`, `resolveReviewThread`).
   - **If anything was escalated,** also post a top-level **Human Decision** comment: for each decision, numbered and kept separate, the ask (the decision, your recommendation, the tradeoff), why it was escalated (which trigger), the evidence (linked threads), and whether it would change scope and how.

7. **Route.**
   - **Accepted, nothing escalated:** done for this round.
   - **Escalated:** stay open. The human may attach to talk it through. When they decide, record the decision on its thread.
   - **Neither:** start the Human Brief subagent with the full text of `human-brief.md` from this skill's folder, plus the repo (the GitHub owner/name and the local checkout path), the PR number, and the brief issue number (or "no brief"). Add nothing else.

8. **Report** one line:
   - `review r<n>: <a> accepted, <e> escalated · PR #<PR>`
   - or `review r<n>: done, Human Brief posted · PR #<PR>`

   With `--report-to`, append it to that file. Otherwise, tell the human.
