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

`install` doesn't install Godot or git-lfs: install them by hand (`brew install --cask godot`, `brew install git-lfs`), and with LFS on, run `git lfs install` once. Godot projects need the Godot version pinned in [`languages/godot/project/.godot-version`](languages/godot/project/.godot-version): if brew's is newer, get that one from [Godot's archive](https://godotengine.org/download/archive/).

The links point into your clone, so editing a skill or running `git pull` takes effect right away. It also means the clone has to stay where it is: if you move it, rerun `./install` to repair the links.

## Start a project

Follow [SETUP.md](SETUP.md): from `copier copy` to a repo with the GitHub settings BaseCamp expects.

## Languages

Each language is a plug-in: one folder under [`languages/`](languages/) holding everything that is only that language's. The core in [`template/`](template/) is what every project shares and names no language.

| In `languages/<language>/` | What it is |
|---|---|
| `project/` | The language's project files, laid out as in a generated project. Copier renders this folder as the project root. |
| `project/{{ '.' }}` | A symlink to `../../../template`. Copier renders its name as `.`, so the core lands in the project root too. |
| `justfile` | The `fmt`, `lint`, `test` and `check` recipes, included into the core `justfile`. |
| `gitignore` | Entries added to the core `.gitignore`. |
| `ci-install` | The shell lines that install the language's tools in CI, put into the project's CI workflow. |
| `tools` | The commands the language needs locally, one per line. The self-test skips the language, with a warning, when one is missing. |
| `name-check.jinja` | Optional. Refuses project names the language can't use, with a message saying why. |
| `editorconfig` | Optional. Sections added to the core `.editorconfig`. |
| `self-test` | Optional. More checks, sourced by [`tests/self-test`](tests/self-test) after the project passes `just check`. |

To add a language, copy an existing folder (`cp -R` keeps the symlink), edit its files, and add its name to `language`'s `choices` in [`copier.yml`](copier.yml). Nothing else changes, docs included. `just check` then generates it and checks it alongside the others.

**Fragments are Jinja.** The core's templates include `justfile`, `gitignore`, `ci-install` and `editorconfig`, so Copier renders them as Jinja, with or without a `.jinja` suffix. A just variable (`{{ name }}`) or an Actions expression (`${{ }}`) left bare renders as empty text, with no error: wrap the fragment in `{% raw %}…{% endraw %}`, as [Godot's `justfile`](languages/godot/justfile) does. In `project/`, only files ending in `.jinja` are rendered.

**Projects own their CI.** A generated project gets a complete `.github/workflows/ci.yml` for its language, as its own file, and may add steps to it. `copier update` merges in template changes like any other file. The job's check is named `check / check`, so rulesets made for the shared workflow keep matching. Older projects, whose `ci.yml` calls the shared `check.yml@ci-v1`, keep working: the `ci-v1` branch is frozen and never moves again, so it keeps that workflow. They switch to their own CI when they run `copier update`.

Locally, `just check` runs every language whose tools are installed and skips the rest with a warning. BaseCamp's own CI installs every language's tools and sets `SELF_TEST_ALL_LANGUAGES=1`, so nothing is skipped there.

## What's here

| Path | What it is |
|---|---|
| [`practices.md`](practices.md) | The rules every project follows: commits, branches, local checks, writing, PR format, shortcuts, comments and names, and the Agent Brief layout. Written as instructions for agents. |
| [`skills/`](skills/) | The loop's Claude Code skills: `/agent-brief`, `/implementation-loop`, `/pr-review`, plus the vendored `/grill-me` and `grilling`. |
| [`docs/`](docs/) | Why things are the way they are: the loop, the practices, and what gets recorded for retrospectives. |
| [`SETUP.md`](SETUP.md) | The walkthrough for starting a project: generate it, push it, and set up its GitHub repo. |
| [`install`](install) | Sets up a machine: links the skills and practices, checks for tools. |
| [`.github/workflows/`](.github/workflows/) | BaseCamp's own CI, which runs `just check` with every language's tools installed. |
| [`template/`](template/) | The core of the [Copier](https://copier.readthedocs.io/) project template, configured by [`copier.yml`](copier.yml). |
| [`languages/`](languages/) | One plug-in folder per language. See [Languages](#languages). |

Coming next: a first end-to-end run in a sandbox project.

## License

BaseCamp is [MIT licensed](LICENSE). Files under [`skills/third-party/`](skills/third-party/) are vendored from other projects and keep their own licenses, included alongside them.

## Credits

- **[Matt Pocock's skills](https://github.com/mattpocock/skills):** `/grill-me` and `grilling`, vendored as is.
- **[Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert:** the ideas behind the Fit & Impact reviewer's Minimalist ladder, its never-flag list, and shortcut comments.
