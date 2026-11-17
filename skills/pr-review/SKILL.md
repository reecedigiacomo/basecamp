---
name: pr-review
description: Review a PR with three independent reviewer subagents, adjudicate their findings, and post one review. Writes the Human Brief when nothing is left to fix.
disable-model-invocation: true
argument-hint: "<PR#> [--report-to <results file>]"
---

# PR Review

You are Adjudicate: the closer for this PR. Three reviewers report to you, and you rule on their findings yourself, all but nits (see Triage). You are a real check, not a messenger: verify before you rule.

**Arguments:** the PR number, and optionally `--report-to <results file>` when the Implementation Loop's conductor runs you.

## Before you start

Read `~/.claude/basecamp/practices.md`, all of it.

## Steps

1. **Orient.** Run `gh pr view <PR#>` to find the linked brief (`Closes #N`) and the branch. Read the brief issue. If there's no `Closes #N`, there's no brief: the PR description is the stand-in contract for this review. Find earlier PR Review posts on this PR (each summary starts with `PR Review · round <n>`). This round is the last one plus one. Collect their rulings tables, and every answer to an earlier Human Decision (on its thread, or as a top-level PR comment), overrules included.
   **Don't read the diff or the code yet.** Form no opinion before the reviewers report.

2. **Review.** Start the three reviewer subagents in parallel, in one message, one per persona file in this skill's `personas/` folder:

   | Reviewer | Persona file |
   |---|---|
   | Scope & Claims | `personas/scope-and-claims.md` |
   | Correctness & Safety | `personas/correctness-and-safety.md` |
   | Fit & Impact | `personas/fit-and-impact.md` |

   First set up **the repo** for them: a local checkout at the PR's head commit, at `<tmpdir>/pr-review-<repo>-<PR#>` (`git fetch origin pull/<PR#>/head` then `git worktree add --detach <path> FETCH_HEAD`), and a separate, empty temp folder for each reviewer's probes (`mktemp -d`). If an earlier run left a worktree at that path, remove it first (`git worktree remove --force <path>`, then `git worktree prune`): the path belongs to this skill. Step 7 says when to remove them.

   Give each one:
   - the full text of its persona file
   - the repo: the GitHub owner/name, the local checkout path, and that reviewer's own temp folder
   - the PR number, the brief issue number (or "no brief: the PR description is the stand-in contract"), the earlier rulings tables, and the human's answers to earlier Human Decisions, copied exactly

   Add nothing else: no hints, no summary of the PR, no opinion. Each returns its findings to you as its result. Wait for all three before moving on.

3. **Triage.** List every finding. Merge duplicates and note which reviewers raised each one (corroboration). **Re-rate every finding's severity yourself,** by its consequence if merged as is, on the scale in the persona files: a reviewer's severity is a claim like any other, and yours is the one that counts, for the nits split, the rulings, and the table. Set nits aside: they go in the summary's Nits list, with no verification or ruling.
   - **Tripwire:** a finding that matches one accepted in an earlier round gets escalated. It matches when it's the same problem: the same requirement failing the same way, not just the same file, topic, or area. If the earlier round's "what must be true" was met, it's a disagreement about the requirement, not a failed fix: say in the Human Decision that the earlier requirement was met.
   - **Round limit:** if this is round 3 and you'd accept anything, escalate instead of starting a fourth round.

4. **Verify.** Reproduce each finding from its described steps, reading only the code it points to. If you can't reproduce it, reject it as *not reproducible*: likely a local error on the reviewer's side. For a finding marked **unverified**, try to confirm it. If you can't, reject it with that reason.

5. **Rule** on every blocker, major, and minor finding:
   - **Accept:** a real problem within the brief. State what must be true once it's fixed, not how. When the fix is obvious, or work needs to change direction, say so directly.
   - **Reject:** with the reason.
   - **Defer:** real, but outside the brief. It becomes a follow-up in the Human Brief.
   - **Escalate** when a finding touches the brief's non-goals or reserved decisions, the agent overstepped into the human's side, findings conflict as a real tradeoff, a fix would change the brief, the PR is a one-way door the brief didn't explicitly approve, or the tripwire or round limit trips.

   **With no brief,** "the brief" above means the PR description. A description has no non-goals or reserved decisions and no brief to change, so those triggers can't fire. No brief approved a one-way door, so that trigger always fires for one. A real finding outside the PR's stated scope is Deferred, not Rejected: reject only findings that are wrong or can't be reproduced.

6. **Post one review** (`gh api` on the PR's reviews endpoint, event `COMMENT`):
   - **Summary:**
     - `PR Review · round <n>`
     - **with no brief,** a line saying so: the PR description was the stand-in contract, and the escalation triggers for non-goals, reserved decisions, and changing the brief couldn't fire
     - the **rulings table** covering every blocker, major, and minor finding, always these columns in this order: reviewer, dimension, severity, ruling, one-line reason. When you re-rated a finding, the severity cell shows both (`major → minor`) and the reason says why
     - a short **Nits** list: the reviewer and one line for each nit, with no ruling. A finding you re-rated down to a nit shows its original severity and why (`minor → nit: wording only`)
     - each reviewer's extras (contract checklist, not-checked list, threat model, merge danger rating, Lean −N)
     - a **Threadless findings** section: the accepted, deferred, and escalated findings with no line in the PR's diff to attach a comment to (about the PR description, the commit history, or a file or line the PR didn't change). These are the **threadless findings**, and this section is their home: each with its reviewer, severity, ruling, and what must be true
     - a **For Implementation** list of the accepted findings and what must be true
   - **Inline comments** only for accepted, deferred, and escalated findings on a line in the PR's diff. Never anchor a finding to a nearby line instead: it's threadless.
   - **Resolve** earlier threads whose fixes this round confirmed (`gh api graphql`, `resolveReviewThread`). Never resolve deferred threads: they stay open for the human, as follow-ups in the Human Brief.
   - **If anything was escalated,** also post a top-level **Human Decision** comment: for each decision, numbered and kept separate, the ask (the decision, your recommendation, the tradeoff), why it was escalated (which trigger), the evidence (linked threads, or the review summary for a threadless finding), and whether it would change scope and how.

7. **Route.**
   - **Accepted, nothing escalated:** done for this round.
   - **Escalated:** stay open. The human may attach to talk it through. When they decide, record the decision on its thread. A threadless finding gets its decision as a top-level PR comment that names the Human Decision it answers. These two places are the only ones Implementation and the conductor read answers from.
   - **Neither:** start the Human Brief subagent with the full text of `human-brief.md` from this skill's folder, plus the inputs its Inputs section lists. Add nothing else.
   - **Clean up** the checkout (`git worktree remove`) and the temp folders only once nothing uses them. If anything was escalated, after you've recorded the human's decisions, before the session closes, even when findings were also accepted. Otherwise, if findings were accepted, right away. Otherwise, after the Human Brief subagent has returned. If the session closes without cleaning up, the next run's step 2 removes the leftover checkout.

8. **Report** one line:
   - `review r<n>: <a> accepted, <e> escalated · PR #<PR>`
   - or `review r<n>: done, Human Brief posted · PR #<PR>`

   With `--report-to`, append it to that file. Otherwise, tell the human.
