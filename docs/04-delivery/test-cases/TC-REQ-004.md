---
doc_id: TC-REQ-004
title: Test cases — REQ-004 Document versioning
req: REQ-004
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-004 Document versioning

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-004.1 | AC-004.3 | Positive | Document register created | New install | Check `docs/index.md` | Exists | Auto | `tests/setup.test.sh › "TC-004.1 document register docs/index.md created"` | Not run |
| TC-004.2 | AC-004.2 | Positive | Spec templates have version, status, approval and revision history | New install | grep BRD, PRD, tech-design and test-plan templates | All four fields present in each | Auto | `tests/setup.test.sh › "TC-004.2 spec templates have version, status, approval and revision history"` | Not run |
| TC-004.3 | AC-004.1 | Positive | AGENTS.md §4 defines header, status flow, freeze-on-approval and bump rules | — | Read AGENTS.md §4 | All four are defined | Manual |  | Not run |
| — | AC-004.1–004.3 | Negative | N/A — static rule text; a missing field fails TC-004.2 |  |  |  |  |  | — |
