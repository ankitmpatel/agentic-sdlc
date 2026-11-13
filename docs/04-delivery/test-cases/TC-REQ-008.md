---
doc_id: TC-REQ-008
title: Test cases — REQ-008 Test management
req: REQ-008
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-008 Test management

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-008.1 | AC-008.1 | Positive | manage-tests skill with all four templates | New install | Check files | SKILL.md, test-plan, test-cases, test-run and defect templates present | Auto | `tests/setup.test.sh › "TC-008.1 manage-tests skill with plan, case, run and defect templates"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-008.2 | AC-008.2 | Positive | Rules require a positive and a failure case per AC | New install | grep AGENTS.md and the skill | Coverage rule present in both | Auto | `tests/setup.test.sh › "TC-008.2 rules require a positive and a failure case per AC"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-008.3 | AC-008.3 | Positive | Run and defect templates capture per-TC results, failure classification and reproduction steps | New install | grep templates | All three sections present | Auto | `tests/setup.test.sh › "TC-008.3 test-run and defect templates record per-TC results, failures and reproduction"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-008.4 | AC-008.4 | Positive | test-cases, test-runs and defects folders created | New install | Check folders | All exist | Auto | `tests/setup.test.sh › "TC-008.4 test-cases, test-runs and defects folders created"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-008.5 | AC-008.4 | Negative | Recorded runs and defects survive re-install | RUN and BUG files present | Re-run | Files unchanged | Auto | `tests/setup.test.sh › "TC-008.5 recorded test runs and defects are kept on re-run"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| — | AC-008.2–008.3 | Negative | N/A — rule text; whether agents follow it is checked by the reviewer on each PR (review-pr §2 C, D) |  |  |  |  |  | — |
