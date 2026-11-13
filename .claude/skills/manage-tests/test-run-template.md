---
run_id: RUN-YYYYMMDD-HHMM-<scope>
date: YYYY-MM-DDTHH:MMZ
run_by: reviewer (agent)
scope: PR #<n> | branch <name> | release-<version>
items: [REQ-000]
commit: <short sha>
branch: <branch>
environment: <OS, runtime and tool versions>
exit_criteria: Met | Not met
---

# RUN-YYYYMMDD-HHMM-<scope>

## Commands
| Command | Passed | Failed | Skipped | Duration |
|---|---|---|---|---|
| | | | | |

## Results by test case
| TC | Type | Result | Evidence / notes | Defect |
|---|---|---|---|---|
| TC-000.1 | Positive | Pass | `tests/... › REQ-000 TC-000.1 ...` | |
| TC-000.2 | Negative | Fail | see Failure 1 | BUG-000 |

Totals: <n> pass · <n> fail · <n> skipped · <n> blocked · <n> not run

## Failures
### Failure 1 — TC-000.2 <title>
- **Test:** `<file> › <test name>`
- **Classification:** Product defect | Test defect | Environment
- **Expected:** <from the test case>
- **Actual:**
```text
<relevant lines of the error output>
```
- **Action:** BUG-000 raised | review finding #<n> | re-run in RUN-…

## Exit criteria
| Criterion | Status |
|---|---|
| Every AC has a positive and a failure case | ✅ / ❌ |
| All Must test cases pass | |
| No open Blocker or Major defect | |
| No unexplained skipped or not-run cases | |

**Result: Met | Not met** — <reason>
