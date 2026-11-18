# BaseCamp

The foundation every project starts from: one way of working, plus everything a repo needs to run it.

At the center is the **Implementation Loop**: a human sets the direction in a short, approved brief, and agents handle the bounded implementation, review, and verification, coming back to the human only when judgment is needed. Everything else in BaseCamp supports that loop: shared practices set the rules, CI enforces what a machine can check, skills package each stage as a command, and a project template sets all of it up in a new repo.

> **Status:** Early. The practices, loop skills, docs, install script, project template, CI, and setup guide are written.

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

Fork the repo first: your fork is where you'll edit `practices.md` and the skills to fit how you work. Then clone your fork:

```sh
git clone https://github.com/<you>/basecamp
cd basecamp
./install --dry-run   # see the plan first
./install
```

`install` links the skills into `~/.claude/skills` and `practices.md` into `~/.claude/basecamp/`, then checks for the tools BaseCamp uses (`copier`, `just`, `rustup`, `gh`). It shows a plan first, then asks before linking a skill, replacing anything, or installing a tool. `practices.md` is linked without asking, since the BaseCamp skills read it, and skills you name with `--skills` skip the "Link skill?" question. Anything real it replaces is moved to a backup, never deleted; a replaced link is printed with its old target. Run `./install --help` for options, such as choosing which skills to link or where.

`install` doesn't install Godot or git-lfs: install them by hand (`brew install --cask godot`, `brew install git-lfs`), and with LFS on, run `git lfs install` once. Godot is needed by Godot projects and by BaseCamp's own `just check`, whose self-test checks a Godot project. Both need the version pinned in the template's `.godot-version`: if brew's is newer, get that one from [Godot's archive](https://godotengine.org/download/archive/).

The links point into your clone, so editing a skill or running `git pull` takes effect right away. It also means the clone has to stay where it is: if you move it, rerun `./install` to repair the links.

## Start a project

Follow [SETUP.md](SETUP.md): from `copier copy` to a repo with the GitHub settings BaseCamp expects.

## What's here

| Path | What it is |
|---|---|
| [`practices.md`](practices.md) | The rules every project follows: commits, branches, local checks, writing, PR format, shortcuts, comments and names, and the Agent Brief layout. Written as instructions for agents. |
| [`skills/`](skills/) | The loop's Claude Code skills: `/agent-brief`, `/implementation-loop`, `/pr-review`, plus the vendored `/grill-me` and `grilling`. |
| [`docs/`](docs/) | Why things are the way they are: the loop, the practices, and what gets recorded for retrospectives. |
| [`SETUP.md`](SETUP.md) | The walkthrough for starting a project: generate it, push it, and set up its GitHub repo. |
| [`install`](install) | Sets up a machine: links the skills and practices, checks for tools. |
| [`.github/workflows/`](.github/workflows/) | CI. `check.yml` is the reusable check generated projects call with their language; `ci.yml` runs BaseCamp's own `just check`. |
| [`template/`](template/) | The [Copier](https://copier.readthedocs.io/) project template, configured by [`copier.yml`](copier.yml): a language-neutral core plus a Python, Rust or Godot layer. `just test` generates one project of each and checks them. |

Coming next: a first end-to-end run in a sandbox project.

## License

BaseCamp is [MIT licensed](LICENSE). Files under [`skills/third-party/`](skills/third-party/) are vendored from other projects and keep their own licenses, included alongside them.

## Credits

- **[Matt Pocock's skills](https://github.com/mattpocock/skills):** `/grill-me` and `grilling`, vendored as is.
- **[Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert:** the ideas behind the Fit & Impact reviewer's Minimalist ladder, its never-flag list, and shortcut comments.
