# BaseCamp's code is a few shell scripts and a template, so there is no formatter.
fmt:
    @echo "Nothing to format."

lint:
    bash -n install
    sh -n tests/self-test template/.githooks/pre-commit
    for f in languages/*/self-test; do sh -n "$f"; done
    for f in languages/*/ci-install; do bash -n "$f"; done
    if grep -nE '\{\{|\{%|\{#' languages/*/ci-install; then echo "ci-install must be plain shell with no Jinja delimiters (double braces, {% or {#): BaseCamp's CI runs it raw, and Copier renders it" >&2; exit 1; fi
    jq empty template/.claude/settings.json

# Template self-test: generates a project for each language and checks it.
test:
    tests/self-test

# Checks everything without changing anything.
check: lint test
