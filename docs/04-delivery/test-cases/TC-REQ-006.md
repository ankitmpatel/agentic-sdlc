---
doc_id: TC-REQ-006
title: Test cases — REQ-006 Ask-when-in-doubt protocol
req: REQ-006
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-006 Ask-when-in-doubt protocol

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-006.1 | AC-006.1 | Positive | AGENTS.md has the ask-don't-assume protocol | New install | grep AGENTS.md | Section present | Auto | `tests/setup.test.sh › "TC-006.1 AGENTS.md has the ask-don't-assume protocol"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-006.2 | AC-006.2 | Positive | Every agent ends with "Questions for the human" | New install | grep each agent | Present in all | Auto | `tests/setup.test.sh › "TC-006.2 every agent ends with Questions for the human"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| — | AC-006.1–006.2 | Negative | N/A — static rule text; agent behaviour at runtime is verified in use, not by this suite |  |  |  |  |  | — |
