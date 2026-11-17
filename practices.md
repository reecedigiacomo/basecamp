# Practices

The rules every project follows. Read all of it before you work: every section applies.

## Commit standard

### Format

Use Conventional Commits: `type(scope): summary`.

- **Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `build`, `perf`, `style`.
- **Scope:** the part of the project the commit touches. Optional.
- **Summary:** what changed, in plain words.
- **Body:** optional. Use it when the reason isn't obvious from the summary.

### Size

One logical change per commit. Every commit passes local checks (`just check`) on its own.

### History

Prefer adding new commits over rewriting existing ones. You may rewrite history on your own branch when that makes it clearer, using `git push --force-with-lease`. When you do, say so in the Human Brief.

### Authorship

Commits made by an agent session acting as the implementer end with a Claude co-author line, whether the conductor started that session or the human routed the work to it by hand, and whether or not the work has a brief. Every other commit, including ones from the human's own sessions, has the human as its only author.

## Branches and merging

- **Never merge to `main`.** Only the human merges, unless they explicitly give you permission.
- **Never push to `main`,** and never force-push to it. `main` only changes through a merged PR.
- **Loop branches** are named `brief/<issue#>-<short-slug>` and live in their own worktree at `.claude/worktrees/<issue#>`.
- **Force-push only your own branch,** and only with `--force-with-lease`.
- **Never delete branches.**
- **Link every PR to its brief** with `Closes #N` at the top of the description, so the issue closes when the PR merges.

## Local checks

Every project has the same four commands:

| Command | What it does |
|---|---|
| `just fmt` | Formats the code |
| `just lint` | Runs the linter |
| `just test` | Runs the tests |
| `just check` | All of the above, checking without changing anything |

- **The pre-commit hook runs `just check`** before every commit. A failing check blocks the commit. Fix the problem, then commit.
- **Never bypass the hook with `--no-verify`** unless the human explicitly gives you permission.

## PR format

The PR description is the permanent record of what the code is. Open the PR as a draft, and rewrite the description every loop round so it always matches the current code. Never add "update: fixed X" notes on top.

### Title

Conventional Commits (`type(scope): summary`), with the summary making the PR's focus clear. With squash-merge, the title becomes the commit message on `main`.

### Layout

```markdown
Closes #N

## Summary
## Implementation notes
## Testing
## Merge danger
```

#### Summary

1–3 sentences on what the PR does and why.

When structure changes (modules, functions, flow), add a Mermaid diagram showing only the area around the change, using this legend:
- **added:** green
- **changed:** amber
- **removed:** red and dashed
- **unchanged context:** grey

Docs-only and similar PRs skip the diagram.

#### Implementation notes

What makes this implementation the one we have. Don't list changes file by file or line by line; the diff already shows that. Include each part only when there's something to say:
- **Key decisions and why**
- **Alternatives considered and dropped**
- **Known limitations**, including every `shortcut:` comment this PR adds

#### Testing

A status line copied from a real `just test` run, then a reason for every change:

```markdown
**All 48 pass, 2 skipped** (`just test`)
- **Added:** `test_parses_quoted_fields` covering quoted fields that contain commas.
- **Changed:** `test_parse_basic` updated because blank lines are now skipped instead of raising an error.
- **Skipped:** `test_gpu_path` (no GPU in CI).
```

- Never write the status line by hand.
- Every skipped test needs a reason.
- Include benchmarks only when the brief names performance.

#### Merge danger

- **Door:** **one-way** (hard or impossible to undo: data migrations, public interfaces, deletions, releases) or **two-way** (a revert undoes it).
- **Blast radius:** a level, plus one line saying what's affected.
  - **none:** no effect on how the software behaves (docs, comments, test-only changes)
  - **low:** stays inside one module, and nothing that depends on it behaves differently
  - **medium:** changes behavior that other parts of the project depend on
  - **high:** reaches outside the project, or across most of it: a public interface, a data or storage format, configuration, security, or a dependency upgrade

## Shortcuts

When you deliberately take a shortcut, mark it with a comment in this form:

```
shortcut: <its limit>, <when to upgrade>
```

Example: `# shortcut: loads the whole file into memory, fine under ~100MB. Upgrade to streaming if inputs get bigger.`

- **It records a decision, not an oversight.** Reviewers don't flag the limit it names.
- **List it in the PR** under Known limitations.

A shortcut can never:
- cover validation of untrusted input, error handling that prevents data loss, security, or accessibility
- fall short of a requirement in the brief

If its limit will realistically be hit, it's not a shortcut. Do it properly.

## Comments and names

- **Comments explain why,** in as few lines as it takes. The code already shows what it does. Don't write comments that repeat the code.
- **Names say what something is.** Tests name the behavior they check (`test_skips_blank_lines`, not `test_1`). Variables and functions name their role (`message_count`, not `n2`).

## Agent Brief

The contract for a piece of work: say what done looks like, then get out of the way. The human approves it before it's posted. It lives as a GitHub issue, and its edit history records any changes after Human Decisions.

### Layout

```markdown
## Context

## What to deliver

## Where to stop

## Local decisions

## Performance
```

- **Context:** why this work exists, with links. Short.
- **What to deliver:** each required behavior, and how to verify it.
- **Where to stop:** non-goals, and the decisions reserved for the human.
- **Local decisions:** the goal and constraints within which the agent decides on its own.
- **Performance:** optional. Include it only when performance matters. Its presence means the PR includes benchmarks.

### Updates

When a Human Decision changes scope, update the brief to match. The issue's edit history keeps the record.
