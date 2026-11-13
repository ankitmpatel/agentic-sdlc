---
src_id: SRC-007
title: REQ-009 decisions and approval (stack, git, GitHub protection)
channel: chat
from: Project owner
participants: Claude (main session)
received: 2026-11-13
captured: 2026-11-13
captured_by: main session (Claude)
reference: Claude Code chat session, multiple-choice questions asked by the main session
attachments: none
type: Answer
status: Incorporated (PRD-v1.1, DEC-004)
linked: [REQ-009, PRD-v1.1, TEST-PLAN v1.1, DEC-004]
---

# SRC-007 — REQ-009 decisions and approval

## Summary
The owner approved REQ-009, PRD-v1.1 and its test cases for immediate build ("Approve and build now"). They chose a stack menu, chose that the installer must not touch git, and chose to keep GitHub branch protection manual.

## Extracted items
| # | Question | Answer | Type | Related ID |
|---|---|---|---|---|
| 1 | How to proceed with REQ-009 (PRD-v1.1)? | Approve and build now: approval of PRD-v1.1 (REQ-009) and its test cases recorded, review in the PR | Answer | PRD-v1.1, TEST-PLAN v1.1 |
| 2 | What should the script do with git? | Don't touch git | Answer | REQ-009, DEC-004 |
| 3 | How should the stack skill be set up? | Ask which stack: menu plus `--stack`, only the chosen ones installed | Answer | REQ-009 |
| 4 | Should the script protect main on GitHub? | Never, keep manual | Answer | REQ-009, DEC-004 |

## Questions raised
- none

## Original content
Redactions: none

```text
Q: REQ-009 ... How do you want to proceed?            A: Approve and build now (Recommended)
Q: After installing, what should agent-setup.sh do with git in the target project?   A: Don't touch git
Q: How should agent-setup.sh set up the stack skill?  A: Ask which stack (Recommended)
Q: Should agent-setup.sh protect the main branch on GitHub?   A: Never, keep manual
```
