---
name: agent-brief
description: Turn a finished grilling session into an Agent Brief and post it as a GitHub issue once the human approves.
disable-model-invocation: true
---

# Agent Brief

Turn the shared understanding from this session's grilling into an Agent Brief: the contract for the work. Say what done looks like, then get out of the way.

## Before you start

- **This session must contain a finished grilling session** (`/grill-me`). If it doesn't, stop and tell the human to grill first. Never invent the content of a brief.
- **Read `~/.claude/basecamp/practices.md`,** all of it. Its Agent Brief section defines the layout.
- **Confirm you're in the project's repo** and `gh` can reach it (`gh repo view`).

## Steps

1. **Draft the brief** from what the grilling settled, using the Agent Brief layout, sized to the task as that section says.
   - **What to deliver:** every required behavior, each with how to verify it. A behavior with no way to verify it isn't finished. Ask the human how to verify it.
   - **Where to stop:** name the non-goals and the decisions reserved for the human. Anything the grilling marked as the human's call goes here.
   - **Local decisions:** the goal and constraints the agent decides within.
   - **Performance:** only if the grilling made performance a requirement. Otherwise leave the section out.
   - **Title:** a short, plain statement of the outcome.
   - **Size:** propose `small` or `standard`, per the Agent Brief section, with one line on why. When unsure, propose `standard`.
2. **Find the gaps.** If anything the brief needs wasn't settled in the grilling, ask the human now. Don't fill it in yourself.
3. **Show the full draft** to the human, with the proposed size and why. Revise until they explicitly approve it. Approving the brief confirms its size.
4. **Post it** only after approval: write the body to a temp file, then run `gh issue create --title "<title>" --body-file <file>`.
5. **Hand off.** Print the issue link and the next step:
   > Start the build loop in a fresh session: `/implementation-loop #<N>`
