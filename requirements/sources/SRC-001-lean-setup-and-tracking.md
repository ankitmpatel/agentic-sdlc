---
src_id: SRC-001
title: Lean agent setup with full process tracking
channel: chat
from: Project owner
participants: Claude (main session)
received: 2026-11-12
captured: 2026-11-12
captured_by: main session (Claude)
reference: Claude Code chat session, two consecutive messages
attachments: none
type: New
status: Incorporated (PRD-v1.0)
linked: [REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-006, REQ-007, DEC-001, Q-001, Q-002]
---

# SRC-001 — Lean agent setup with full process tracking

## Summary
The owner asked whether all the generated agents and skills were needed. After a recommendation to slim the setup down, they asked for the lean setup with: tracking of the development process; versioned documents with tracking information; tracking of requirements arriving by email, chat and documents; agents that ask questions when in doubt; and a full, standard development process.

## Extracted items
| # | Statement | Type | Related ID | Notes |
|---|---|---|---|---|
| 1 | "I like leaner setup" | New | REQ-001, REQ-002, DEC-001 | Accepts the proposed planner / developer / reviewer roster |
| 2 | "track development process" | New | REQ-005 | |
| 3 | "make sure each documents maintain version, tracking and necessary information" | New | REQ-004 | |
| 4 | "I collect requirements in different format, email, chat, document. I also want to track that." | New | REQ-003 | |
| 5 | "If any doubt agent should ask questions" | New | REQ-006 | Subagents cannot prompt the user directly; see the PRD |
| 6 | "full detailed standard development should be managed" | New | REQ-001, REQ-005, REQ-007 | Interpreted as gated phases: intake → requirements → design → build → verify → review → release |

## Questions raised
- Q-001 — Should raw sources (emails, chats) be committed to git?
- Q-002 — Is a separate QA role needed, or is the reviewer's verification enough?

## Original content
```text
Message 1:
I'm building agents and skils that help me for my development and other activities. Do I really need the diffente agents and skill like mention in .claude folder

Message 2:
I like leaner setup, I also want to track development process, make sure each documents maintain version, tracking and necessary information. I collect requirements in different format, email, chat, document. I also want to track that. If any doubt agent should ask questions. full detailed standard development should be managed
```
