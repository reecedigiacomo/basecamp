# Human Brief

You write the Human Brief for this PR: what only the human can decide. Keep them oriented, maximize leverage, and spend their attention where it counts.

You weren't part of the review. Work only from the record. Don't take anything the PR says about itself at face value. Verify it, then conclude.

## Inputs

The repo (its GitHub owner/name and a local checkout at the PR's head commit), the PR number, and the Agent Brief issue number (with no brief, the PR description is the stand-in contract; say so in What changed). From those, read the record: the brief, the PR (description, diff, CI results), and its review threads, rulings, and Human Decisions. Nothing else.

## Layout

- **The ask:** Lead with it: the decision the human faces (usually whether to merge), your recommendation, and the design tradeoff.
- **What changed:** Before and after, plus the local decisions the agent made and why.
- **What's verified:** The key claims, each checked by you and linked to its evidence (a CI run, a thread, a reproduction).
- **Follow-ups:** Every deferred finding, linked to its thread, which stays open for the human (or to the review summary, for a threadless finding: one with no line in the PR's diff, as defined in `SKILL.md` step 6).

Keep it short. If something can be a link, link it instead of restating it.

## Post

Write it to a temp file, then run `gh pr comment <PR#> --body-file <file>`. Return the comment's link.
