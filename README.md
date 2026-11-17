# BaseCamp

The foundation every project starts from: one way of working, plus everything a repo needs to run it.

At the center is the **Implementation Loop**: a human sets the direction in a short, approved brief, and agents handle the bounded implementation, review, and verification, coming back to the human only when judgment is needed. Everything else in BaseCamp supports that loop: shared practices set the rules, CI enforces what a machine can check, skills package each stage as a command, and a project template sets all of it up in a new repo.

> **Status:** Early. The practices, loop skills, docs, install script, and project template are written. CI is being built next.

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

Review is done by three independent reviewers (Scope & Claims, Correctness & Safety, Fit & Impact), and every finding except a nit is checked and ruled on before anything goes back for fixing. Hard-to-undo decisions always come back to the human.

Full details: [docs/implementation-loop.md](docs/implementation-loop.md).

## Install

```sh
git clone https://github.com/<you>/basecamp
cd basecamp
./install --dry-run   # see the plan first
./install
```

`install` links the skills into `~/.claude/skills` and `practices.md` into `~/.claude/basecamp/`, then checks for the tools BaseCamp uses (`copier`, `just`, `rustup`, `gh`). It shows a plan first, then asks before linking a new skill, replacing anything, or installing a tool. Two things happen without asking: `practices.md` is always linked, since the BaseCamp skills read it, and skills you name with `--skills` are linked directly. Anything it replaces is moved to a backup, never deleted. Run `./install --help` for options, such as choosing which skills to link or where.

The links point into your clone, so editing a skill or running `git pull` takes effect right away. It also means the clone has to stay where it is: if you move it, rerun `./install` to repair the links.

**Make it yours:** fork the repo, then edit `practices.md` and the skills to fit how you work.

## Start a project

```sh
uvx copier copy gh:<owner>/basecamp my-project
```

It asks for the project's name, a one-line description, its language (Python or Rust), and the GitHub owner whose BaseCamp repo hosts the CI workflow. To pick up later template changes, run `uvx copier update` in the project; its README says how.

## What's here

| Path | What it is |
|---|---|
| [`practices.md`](practices.md) | The rules every project follows: commits, branches, local checks, PR format, shortcuts, comments and names, and the Agent Brief layout. Written as instructions for agents. |
| [`skills/`](skills/) | The loop's Claude Code skills: `/agent-brief`, `/implementation-loop`, `/pr-review`, plus the vendored `/grill-me`. |
| [`docs/`](docs/) | Why things are the way they are: the loop, the practices, and what gets recorded for retrospectives. |
| [`install`](install) | Sets up a machine: links the skills and practices, checks for tools. |
| [`template/`](template/) | The [Copier](https://copier.readthedocs.io/) project template, configured by [`copier.yml`](copier.yml): a language-neutral core plus a Python or Rust layer. `just test` generates one project of each and checks them. |

Coming next: reusable CI workflows.

## License

BaseCamp is [MIT licensed](LICENSE). Files under [`skills/third-party/`](skills/third-party/) are vendored from other projects and keep their own licenses, included alongside them.

## Credits

- **[Matt Pocock's skills](https://github.com/mattpocock/skills):** `/grill-me` and `grilling`, vendored as is.
- **[Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert:** the ideas behind the Fit & Impact reviewer's Minimalist ladder, its never-flag list, and shortcut comments.
