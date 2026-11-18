# Practices

The standard conventions every project follows. The rules themselves live in [`practices.md`](../practices.md), one file written as instructions for agents. It's linked to `~/.claude/basecamp/practices.md`, so every skill, reviewer, and project reads the same file. This page explains why each one exists.

- **[Commit standard](../practices.md#commit-standard):** Conventional Commits keep history scannable and machine-checkable, and they make changelogs possible later. One logical change per commit, each passing local checks, means any commit can be reverted or bisected cleanly. New commits are preferred over rewrites so the history shows what each review round changed. Commits from an agent session acting as the implementer carry a co-author line, whether the loop's conductor started it or I routed the work by hand, so the history shows which work an agent wrote. Everything else is mine alone.
- **[Branches and merging](../practices.md#branches-and-merging):** Merging is a hard-to-undo action, so it stays on my side of the Delegation Boundary. A GitHub ruleset protects `main` too (PRs only, no force pushes, no deletion), so the rule doesn't depend on agents remembering it. CI isn't required yet; it will be once the central CI exists. Squash is the only merge method, so each PR lands on `main` as one commit titled by the PR.
- **[Local checks](../practices.md#local-checks):** The same four `just` commands in every language mean I, the agents, and CI all run the same thing. The pre-commit hook makes "each commit passes local standards" automatic instead of something agents have to remember.
- **[Shortcuts](../practices.md#shortcuts):** Marking a deliberate shortcut turns "good enough for now" into a visible decision, so reviewers don't keep flagging it and I can see every known limit. `grep -r "shortcut:"` lists a project's shortcuts for retrospectives.
- **[Comments and names](../practices.md#comments-and-names):** Comments that explain why, and names that say what, keep code readable for the next person or agent.
- **[Agent Brief](../practices.md#agent-brief):** Briefs are GitHub issues so their edit history records every change after a Human Decision, and `Closes #N` links each PR back to its brief. A brief stays as small as its task because the implementer builds what it lists: a brief that lists edge cases gets a test for each.

## PR format

Rules: [practices.md → PR format](../practices.md#pr-format).

- **The description is the permanent record of what the code is,** for anyone reading the PR later, human or agent. That's why it's rewritten every round instead of collecting update notes, and why it's separate from the Human Brief, which is a one-time, decision-focused message for me.
- **Conventional Commits title:** With squash-merge, the PR title becomes the commit message on `main`. Without the format, the one commit that actually lands on `main` would be the only one that skips the commit standard.
- **Summary diagram with a fixed legend:** A picture of only the area around the change, colored the same way every time, shows what was added, changed, and removed at a glance.
- **Implementation notes, not a file list:** The diff already lists files. What it can't show is why the code is the way it is.
- **Testing from a real run:** A hand-written status line can be wrong or optimistic. Copying it from `just test` makes it checkable against CI, and every unexplained skip is how broken tests go unnoticed.
- **Merge danger:** The door says whether a change can be undone. A one-way door is a decision on my side of the Delegation Boundary, so an unapproved one gets escalated. The blast radius says how far the effects reach, with defined levels so the rating means the same thing on every PR.
