# Implementation Loop

An agentic engineering pattern. It starts by defining something that can be iterated on. I set the trajectory, and agents handle the bounded implementation.

## Principles

- **Software is empirical:** Form a hypothesis → make the change → observe the behavior → update the model → repeat.
- **The Delegation Boundary:** Everything is organized around it.
  - **Human side:** Trajectory and hard-to-reverse changes, intent and product judgment, accepted risk, and the domain model.
  - **Agent side:** The local domain: implementation within the brief, and its verification.
- **Briefs cross the boundary:** Agent Briefs go from me to the agent; Human Briefs come back from the agent to me. Both get refined over time to work better for their reader, me or the agent.
- **The loop itself is iterative:** It gets improved through real projects and real work, not designed perfectly up front.

## Stages

0. **Shared understanding:** The agent and I reach shared understanding through a grilling session (`/grill-me`) that fully defines the work.
1. **Define Agent Brief:** The contract for the work, written from the grilling session. I review and approve it, then it's posted as a GitHub issue. *Say what done looks like, then get out of the way.*
   - **What to deliver:** The required behaviors, and how to verify each one.
   - **Where to stop:** Named non-goals, and the decisions reserved for me.
   - **Local decisions:** The goal and constraints that guide the decisions the agent is allowed to make on its own.
   Done with `/agent-brief`, in the same session as the grilling. It fills in the brief template, shows it to me, posts the issue only once I approve, then prints `/implementation-loop #N` for me to start in a fresh session.
2. **Build loop** (`/implementation-loop <issue#>`): Runs on its own from the approved brief until it needs me. A thin **conductor** starts a fresh, named background session for each stage, every round: **implement → review**, repeated until review finds nothing left to fix.
   - **Implement session** (`<repo> #<issue> · implement · r<round>`): Writes the code, local to the brief. Its own checks stop at formatting and unit tests. In round 1 it opens a draft PR linked to the brief issue (`Closes #N`). In later rounds it works from the latest review: accepted findings, and any Human Decisions. **Output:** commits (following the [commit standard](../practices.md#commit-standard)) and an updated PR description.
   - **Review session** (`<repo> #<issue> · review · r<round>`): Runs `/pr-review <PR#>`. The session is **Adjudicate**.
     1. **Orient.** Load the rules, the PR number, the round number, earlier rulings, and the brief link. **Don't read the diff before the reviewers report,** so Adjudicate forms no opinion before the reviews arrive.
     2. **Review.** Start three reviewer subagents in parallel, each in a fresh context, each given **only** the fixed inputs: the Agent Brief, the draft PR, earlier rulings, and the repo (its GitHub name, a local checkout at the PR's head commit, and a temp folder of its own for probes). Adjudicate adds no framing of its own. Each returns structured findings to the session and posts nothing to the PR.
        - **Scope & Claims** (scope, claims, documentation): [persona file](../skills/pr-review/personas/scope-and-claims.md)
        - **Correctness & Safety** (correctness, security): [persona file](../skills/pr-review/personas/correctness-and-safety.md)
        - **Fit & Impact** (fit, impact, minimalist): [persona file](../skills/pr-review/personas/fit-and-impact.md)
     3. **Triage.** Merge duplicates and note corroboration. **Tripwire:** a finding matching one already accepted goes straight to a Human Decision. **Round limit:** after three rounds without a finished product, the loop goes to a Human Decision so it can at least be unblocked.
     4. **Verify.** Reproduce each finding from its described steps, reading only the code it points to. If it can't be reproduced, it's likely a local error on the reviewer's side, so reject it.
     5. **Rule.** **Accept** (a real problem within the brief → back to Implementation), **Reject** (with the reason), **Defer** (real, but out of scope or a nitpick → a follow-up in the Human Brief), or **Escalate** (→ Human Decision).
        - **Escalate when:** a finding touches the brief's non-goals or reserved decisions, the agent overstepped the Delegation Boundary into the human side, findings conflict as a real tradeoff, a fix would change the brief, the PR is a one-way door the brief didn't explicitly approve, or the tripwire or round limit trips.
        - **Back to Implementation:** What must be true once each accepted finding is fixed, not how. When the fix is obvious, or work needs to change direction, say so directly.
     6. **Post.** Adjudicate is the only one that posts to the PR: **one review per round**. Its summary holds a **rulings table** covering every blocker, major, and minor finding (reviewer, dimension, severity, ruling, one-line reason) and a short list of nits with no rulings, and inline threads are opened only for accepted, deferred and escalated findings with a code location. Those about the PR description go in a PR description section of the summary instead. Earlier threads whose fixes this round confirmed get resolved. Deferred and escalated threads stay open for me.
     7. **Route.** Any accepted findings mean another round. Any escalation means a Human Decision request is posted. Neither means the loop is finished, so start the Human Brief subagent. Then append one line with the result to the conductor's results file. Outside the loop, `/pr-review` reports the same thing to me instead.
3. **Human Decision:** Called in whenever judgment is needed. The loop pauses while it waits.
   - **Layout:** The ask (the decision needed, Adjudicate's recommendation, the tradeoff), why it was escalated (which trigger fired), and the evidence (the findings involved, linked to their PR threads). Several escalations can share one request, but each is a separate numbered decision, never merged, and kept short.
   - **Scope changes:** If a decision would change scope, the request says so plainly, along with what it changes. The Agent Brief gets updated to match.
   - **Answering:** I answer on the escalated PR thread. The conductor **keeps that round's review session open**, so I can `claude attach` and talk it through. The session records my decision on the thread before it closes. Then I run `/implementation-loop <issue#>` (or say "resume" to an open conductor), and the decision goes to Implementation with the next round.
   - **Reset:** The tripwire and round limit reset for the affected findings.
4. **Human Brief** (a subagent started by the review session): Written in a fresh context, so the session's rulings and reasoning don't cloud it. It's given only the fixed inputs (the Agent Brief, the PR, and its threads), and it posts its own top-level comment on the PR (not the PR description). What only I can decide. *Keep the human oriented, maximize leverage, and spend human attention where it counts.*
   - **The ask:** Lead with it, along with a recommendation and the design tradeoff.
   - **What changed:** Show before and after, and explain the local decisions the agent made.
   - **What's verified:** Check the key claims and link to the evidence.
   - **Follow-ups:** Deferred findings.

## Running it

```
Session (mine)   /grill-me <idea> → /agent-brief → I approve → issue #12 posted
Session (mine)   /implementation-loop #12        ← conductor
                   ├─ "myapp #12 · implement · r1"   → draft PR                 → "implement r1: PR #34"
                   ├─ "myapp #12 · review · r1"      → /pr-review, 2 accepted    → "review r1: 2 accepted · PR #34"
                   ├─ "myapp #12 · implement · r2"   → fixes                     → ...
                   └─ "myapp #12 · review · r2"      → nothing accepted, Human Brief posted → "review r2: done"
                 conductor stops → short status for me
```

### The conductor

- **Keeps no state of its own.** It reads the issue and the PR to know where things stand, so `/implementation-loop <issue#>` both starts and resumes.
- **Stays thin.** It never reads code or the sessions' conversations, only the one-line result each session appends to the brief's results file (`$TMPDIR/implementation-loop/<repo>-<issue#>.log`). The detail lives on the PR.
- **Names every session** it starts: `<repo> #<issue> · <stage> · r<round>`. Its own name is `<repo> · conductor`; since a session can't rename itself, it asks me to run `/rename` when it starts.
- **Cleans up.** It removes each finished session, except a review session that escalated, which stays open until I've answered.
- **Watches for stuck sessions.** If one shows as waiting in `claude agents`, it tells me: *"Session `<name>` is waiting for you: run `claude attach <name>`."*
- **Stops** for a Human Decision, a waiting session, or a posted Human Brief, and gives me a short status: one line per round so far, why it stopped, and the PR link.

### Where it runs

- **Its own worktree:** each brief gets a separate checkout at `.claude/worktrees/<issue#>` on branch `brief/<issue#>-<slug>`, so the loop never touches the folder I'm working in.
- **Permissions:** stage sessions run in `auto` mode, never with permissions bypassed.
  - **Allowed:** `just`, `git` on the PR branch, `gh pr`, `gh issue`.
  - **Denied (hard to undo, so mine):** pushing or force-pushing to `main`, deleting branches, `rm -rf` outside the worktree, reading credentials.
  - **Force-push:** `--force-with-lease` is allowed only on the loop's own branch, enforced by a hook.

Automate it later with GitHub Actions.

## Best practices

Things I manage. The agent should know them and remind me.

- **Fresh context, automatically:** Every stage runs in a fresh session or subagent, so this mostly happens on its own now. It still applies to anything I run by hand.
- **Cattle, not pets:** Throw sessions away freely and get comfortable doing it.
- **Knowledge lives in handoffs:** Context is temporary. Anything worth keeping, for me or an agent, goes into a handoff: the issue, the PR, or a handoff file.
- **Exceptions (no nudge):** Small tasks that don't need the full loop. Subagents, which already get fresh contexts. A review session kept open on purpose to talk through an escalation. More get added as they come up.

For what gets measured afterward, see [Retrospectives](retrospectives.md).
