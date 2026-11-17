# Set up a new project

From nothing to a repo ready for the Implementation Loop. The GitHub settings are done by hand in the web UI: no BaseCamp script changes them.

## 1. Create the project

- [ ] Generate it from the template:

  ```sh
  uvx copier copy gh:<owner>/basecamp my-project
  ```

  It asks for the project's name, a one-line description, its language (Python or Rust), and the GitHub owner whose BaseCamp repo hosts the CI workflow. To pick up later template changes, the project's README says how to run `uvx copier update`.

## 2. Create the GitHub repo and push

Pick the repo's visibility first: step 4 needs a public repo or a paid plan (on a free personal account or a Free organization, a private repo doesn't enforce rulesets), and step 6 applies only to a public repo.

- [ ] On GitHub, create an empty repo (no README, license, or `.gitignore`), named after the project.
- [ ] Copier doesn't make a git repo, so make one, commit, and push to `main`, using the repo's URL:

  ```sh
  cd my-project
  git init -b main
  git add -A
  git commit -m "chore: start from the BaseCamp template"
  git remote add origin <repo-url>
  git push -u origin main
  ```

## 3. Get started locally

- [ ] Do the "Getting started" section of the project's README ([template](template/README.md.jinja)).

## 4. Protect the default branch

In **Settings → Rules → Rulesets → New ruleset → New branch ruleset**:

- [ ] **Name:** `protect-main`. **Enforcement status:** Active.
- [ ] **Bypass list:** leave it empty.
- [ ] **Target branches:** Add target → Include default branch.
- [ ] **Restrict deletions:** on.
- [ ] **Block force pushes:** on.
- [ ] **Require a pull request before merging:** on, with
  - [ ] **Required approvals:** 0
  - [ ] **Require conversation resolution before merging:** on
  - [ ] **Allowed merge methods:** Squash only
- [ ] Create the ruleset.

The required check only shows up in the picker after CI has run once, so add it after a first PR:

- [ ] Open a first PR and wait for CI to finish.
- [ ] Edit the ruleset: **Require status checks to pass** on, then add `check / check`.

## 5. General settings

In **Settings → General → Pull Requests**:

- [ ] **Allow merge commits:** off.
- [ ] **Allow squash merging:** on, with default message **Pull request title and description**.
- [ ] **Allow rebase merging:** off.
- [ ] **Automatically delete head branches:** on.

## 6. Security

Public repo: turn these on. Private repo: skip this step.

In **Settings → Advanced Security** (named **Code security** on some accounts):

- [ ] **Secret Protection** (secret scanning): enabled.
- [ ] **Push protection:** enabled.
