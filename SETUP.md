# Set up a new project

From nothing to a repo ready for the Implementation Loop. The GitHub settings are done by hand in the web UI: no BaseCamp script changes them.

## 1. Create the project

- [ ] Generate it from the template:

  ```sh
  uvx copier copy gh:<owner>/basecamp my-project
  ```

  It asks for the project's name, a one-line description, its language (Python or Rust), and the GitHub owner whose BaseCamp repo hosts the CI workflow. To pick up later template changes, the project's README says how to run `uvx copier update`.

## 2. Create the GitHub repo and push

- [ ] On GitHub, create an empty repo (no README, license, or `.gitignore`), named after the project.
- [ ] In the project, make the first commit and push it to `main`, following the commands GitHub shows for an existing repository.

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

In **Settings → Advanced Security** (named **Code security** on some accounts):

- [ ] **Secret Protection** (secret scanning): enabled.
- [ ] **Push protection:** enabled.
