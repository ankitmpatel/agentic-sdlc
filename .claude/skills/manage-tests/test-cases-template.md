---
doc_id: TC-REQ-000
title: Test cases — REQ-000 <requirement title>
req: REQ-000
based_on: PRD-v1.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Test cases — REQ-000 <requirement title>

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| YYYY-MM-DD | planner (agent) | Initial test cases | PRD-v1.0 |

## Test cases
Types: Positive · Negative · Boundary · Error · Security · Non-functional. Each AC needs at least one Positive case and one failure case, or `N/A — <reason>`.

| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-000.1 | AC-000.1 | Positive | <valid request succeeds> | <user exists, logged in> | 1. … 2. … | <201, body has id> | Auto | | Not run |
| TC-000.2 | AC-000.1 | Negative | <missing field rejected> | | 1. … | <400, code VALIDATION_ERROR, field "name"> | Auto | | Not run |
| TC-000.3 | AC-000.1 | Boundary | <maximum length accepted / exceeded> | | | | Auto | | Not run |
| TC-000.4 | AC-000.1 | Error | <database unavailable> | | | <503, no partial write> | Auto | | Not run |
| TC-000.5 | AC-000.1 | Security | <other user's record not accessible> | | | <403> | Auto | | Not run |

<!-- Cases added during development go at the bottom, with "Added by: developer" in Preconditions and a revision-history row. Cases are never deleted. To retire one, set Last result to "Retired: <reason>". -->

## Manual case details
<!-- Only for Mode = Manual: the full steps, and why the case isn't automated. -->
