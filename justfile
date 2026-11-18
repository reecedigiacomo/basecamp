# BaseCamp's code is a few shell scripts and a template, so there is no formatter.
fmt:
    @echo "Nothing to format."

lint:
    bash -n install
    sh -n tests/self-test template/.githooks/pre-commit
    for f in languages/*/ci-install languages/*/self-test; do sh -n "$f"; done
    jq empty template/.claude/settings.json

# Template self-test: generates a project for each language and checks it.
test:
    tests/self-test

# Checks everything without changing anything.
check: lint test
