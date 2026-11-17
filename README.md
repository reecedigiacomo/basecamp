# BaseCamp

The foundation every project starts from: one way of working, plus everything a repo needs to run it.

At the center is the **Implementation Loop**: a human sets the direction in a short, approved brief, and agents handle the bounded implementation, review, and verification, coming back to the human only when judgment is needed. Everything else in BaseCamp supports that loop: shared practices set the rules, CI enforces what a machine can check, skills package each stage as a command, and a project template sets all of it up in a new repo.

> **Status:** Early. The practices, loop skills, and docs are written. The install script, project template, and CI are being built next.

## How it works

The whole thing is organized around the **Delegation Boundary**, split into three tiers:

1. **Machines (CI):** anything checkable and mechanical.
2. **Agents:** the local work: implementation and verification within a brief.
3. **The human:** direction, judgment, risk, and merging.

A piece of work goes through the loop like this:

```
/grill-me <idea>           → agent and human reach shared understanding
/agent-brief               → the contract for the work, posted as an issue once approved
/implementation-loop #N    → implement ↔ review rounds, each in a fresh session,
                             until review finds nothing left to fix
                             → a Human Brief on the PR: what only the human can decide
```

Review is done by three independent reviewers (Scope & Claims, Correctness & Safety, Fit & Impact), and every finding is checked and ruled on before anything goes back for fixing. Hard-to-undo decisions always come back to the human.

Full details: [docs/implementation-loop.md](docs/implementation-loop.md).

## What's here

| Path | What it is |
|---|---|
| [`practices.md`](practices.md) | The rules every project follows: commits, branches, local checks, PR format, shortcuts, comments and names, and the Agent Brief layout. Written as instructions for agents. |
| [`skills/`](skills/) | The loop's Claude Code skills: `/agent-brief`, `/implementation-loop`, `/pr-review`, plus the vendored `/grill-me`. |
| [`docs/`](docs/) | Why things are the way they are: the loop, the practices, and what gets recorded for retrospectives. |

Coming next: `install` (links the skills and practices into `~/.claude`), `template/` (a [Copier](https://copier.readthedocs.io/) template with Python and Rust layers), and reusable CI workflows.

## License

BaseCamp is [MIT licensed](LICENSE). Files under [`skills/third-party/`](skills/third-party/) are vendored from other projects and keep their own licenses, included alongside them.

## Credits

- **[Matt Pocock's skills](https://github.com/mattpocock/skills):** `/grill-me` and `grilling`, vendored as is.
- **[Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert:** the ideas behind the Fit & Impact reviewer's Minimalist ladder, its never-flag list, and shortcut comments.
