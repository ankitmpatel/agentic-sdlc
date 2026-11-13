---
doc_id: TC-REQ-005
title: Test cases — REQ-005 Development process tracking
req: REQ-005
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-005 Development process tracking

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-005.1 | AC-005.1 | Positive | Tracking files and folders created | New install | Check paths | Traceability, questions, decisions, ledger, progress template, CHANGELOG, ADR and reviews folders exist | Auto | `tests/setup.test.sh › "TC-005.1 tracking files created"` | Not run |
| TC-005.2 | AC-005.2 | Positive | AGENTS.md defines gates and ledger events | New install | grep AGENTS.md | `Gate A` and `test_run_recorded` present | Auto | `tests/setup.test.sh › "TC-005.2 AGENTS.md defines gates and the ledger events"` | Not run |
| TC-007.4 | AC-005.1 | Negative | Tracking data survives re-install (shared with REQ-007) | — | See TC-REQ-007 | — | Auto | `tests/setup.test.sh › "TC-007.4 activity ledger and traceability rows kept"` | Not run |
