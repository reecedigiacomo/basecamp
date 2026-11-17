# Retrospectives

Looked at afterward, across PRs and projects, to improve the loop. Not built into the loop's stages.

**Record first, measure later.** For now, only raw facts get recorded. How they're scored and which metrics matter get defined once a few real loops have produced data. Deciding too early would bias them toward guesses. A `/retro` skill to calculate them comes then, too.

## Sources

Only lasting ones:
- **GitHub:** PR Reviews (their rulings tables always use the same columns, in the same order), Human Decisions, Human Briefs, merges, issue edits, and labels.
- **Claude Code session logs:** tokens and cost per session, grouped by session name (`<repo> #<issue> · <stage> · r<round>`).

The conductor's results file is temporary and isn't a source.

## What gets recorded

- **Agreement:** One data point per **decision**: each numbered item in a Human Decision, and each merge outcome against the Human Brief's recommendation. Record what the agent recommended, what I chose, and the outcome:
  - **Agreed:** I took the recommendation as is.
  - **Agreed with changes:** I took it, with changes.
  - **Reversed:** I went a different way than the agent recommended, including undoing work it already did.
- **Interventions:** Each time the loop pulls me in. One Human Decision request is one intervention, however many decisions it holds.
- **Code health:** Coupling (files that change together), hotspots (files we keep going back to).
- **Process cost:** Tokens from Agent Brief to Human Brief, iterations per brief, interventions per brief, my time per brief.
- **Review quality:** Acceptance rate per reviewer, rejection reasons, corroboration rate (findings raised by two or more reviewers, and how often those get accepted), and escaped bugs (issues labeled `escaped`, linked to the PR that introduced them).
- **Loop health:** Tripwire and round-limit hits, escalations by trigger, changes to the brief mid-loop, deferred follow-ups.
- **Easier vs. harder:** What each change made easier and what it made harder.

## On hold

- **"Your take" in the Human Brief,** and reactions on rulings: ways to capture my view of rulings I never acted on. Added only if the data shows gaps.
