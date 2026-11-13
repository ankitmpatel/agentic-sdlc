---
doc_id: TEST-PLAN
title: Test Plan — <project>
version: 1.0
status: Draft
owner: <human owner>
created: YYYY-MM-DD
updated: YYYY-MM-DD
approved_by:
approved_on:
supersedes:
prd: PRD-v1.0
design: tech-design-v1.0.md
sources: [PRD-v1.0]
---

# Test Plan — <project>

## Revision history
| Version | Date | Author | Change | Reason |
|---|---|---|---|---|
| 1.0 | YYYY-MM-DD | planner (agent) | Initial draft | PRD-v1.0 |

## 1. Scope
**In scope:** REQ-001 … REQ-0NN (PRD-v1.0)
**Out of scope:** <what isn't tested, and why>

## 2. Test levels and tools
| Level | What it covers | Tool / command | Owner |
|---|---|---|---|
| Unit | Business logic, validation | <from the stack skill> | developer |
| Integration | API endpoints against the contract, database | | developer |
| E2E | User journeys through the UI, selected by `data-testid` | | developer |
| Manual | Cases that can't practically be automated | Steps in the test case files | reviewer |
| Non-functional | Performance, accessibility, security | | developer |

## 3. Environments and test data
<Local / CI / staging, runtime versions, how test data is created and cleaned up, and the rule that no production data is used.>

## 4. Entry criteria (testing can start)
- Test cases approved at Gate B
- Build compiles; environment available

## 5. Exit criteria (ready for merge / release)
- Every acceptance criterion has a positive and a failure test case (or a recorded N/A reason)
- 100% of `Must` test cases pass in the latest RUN; no test case `Not run` without a reason
- No open `Blocker` or `Major` defect
- No skipped tests without a linked question or defect

## 6. Regression suite
<Which suites run on every PR and which run before release, and the expected duration.>

## 7. Risks
| Risk | Impact | Mitigation |
|---|---|---|
