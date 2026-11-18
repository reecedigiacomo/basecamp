# BaseCamp's code is a few shell scripts and a template, so there is no formatter.
fmt:
    @echo "Nothing to format."

lint:
    bash -n install
    sh -n tests/self-test template/.githooks/pre-commit
    jq empty template/.claude/settings.json

# Template self-test: generates a Python, a Rust and a Godot project and checks each.
test:
    tests/self-test

# Checks everything without changing anything.
check: lint test
