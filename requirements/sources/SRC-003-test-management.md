---
src_id: SRC-003
title: Documented testing — test cases, failure cases and test results
channel: chat
from: Project owner
participants: Claude (main session)
received: 2026-11-13
captured: 2026-11-13
captured_by: main session (Claude)
reference: Claude Code chat session
attachments: none
type: New
status: Incorporated (PRD-v1.0)
linked: [REQ-008, Q-003, Q-004]
---

# SRC-003 — Documented testing: test cases, failure cases and test results

## Summary
The owner asked how tests are managed after development, and wants functionality to be tested, with test cases and failure cases documented.

## Extracted items
| # | Statement | Type | Related ID | Notes |
|---|---|---|---|---|
| 1 | "how do you manage all tests after development" | New | REQ-008 | Answer: the Verify phase, with RUN reports and release regression |
| 2 | "functionalty shoud be tested" | New | REQ-008 | Every AC is covered by test cases, each automated or manual |
| 3 | "testcases ... should be docuemnted" | New | REQ-008 | Test-case files per REQ |
| 4 | "failure cases should be docuemnted" | New | REQ-008 | Read two ways, both covered: negative test cases, and failed test results (RUN failures + BUG records) |

## Questions raised
- Q-003 — Human UAT sign-off before merge?
- Q-004 — Numeric code-coverage threshold?

## Original content
Redactions: none

```text
how do you manage all tests after development, i want functionalty shoud be tested and testcases and failure cases should be docuemnted.
```
