---
name: manage-tests
description: Test management across the lifecycle — write the test plan and documented test cases (positive and failure/negative cases) from acceptance criteria, automate each test case, record every verification or regression run as a RUN report with per-test-case results, and document every failure as a BUG defect record through to verified fix. Use when designing tests (with the technical design), implementing tests, running verification, handling a failing test, or preparing a release.
---
# Manage tests

Templates in this folder: `test-plan-template.md`, `test-cases-template.md`, `test-run-template.md`, `defect-template.md`.

| File | Location | Kind |
|---|---|---|
| Test plan | `docs/04-delivery/test-plan-vX.Y.md` | Versioned spec (`AGENTS.md` §4), one per PRD version |
| Test cases | `docs/04-delivery/test-cases/TC-REQ-###.md`, one per REQ | Living document: edit in place, never delete or renumber a TC |
| Test runs | `docs/04-delivery/test-runs/RUN-YYYYMMDD-HHMM-<scope>.md` | Write once: never edit a recorded run, record a new one instead |
| Defects | `docs/04-delivery/defects/BUG-###-<slug>.md` | Living document until `Closed` |

## 1. Design test cases (planner, phase 2, approved at Gate B)
1. Write the test plan for the PRD version from `test-plan-template.md`: scope, levels and tools, environments and test data, entry and exit criteria, and the regression suite.
2. For every in-scope REQ, create `TC-REQ-###.md` from `test-cases-template.md`. Derive the cases **from the acceptance criteria, not from the code**.
3. **Coverage rule:** each acceptance criterion gets at least:
   - one **Positive** case (the expected behavior), and
   - one **failure** case: **Negative** (invalid, missing or unauthorized input), **Boundary** (limits, empty, maximum), **Error** (a dependency fails, times out, or returns bad data) or **Security**.

   If a failure case truly doesn't apply, write `N/A — <reason>` in that row instead of leaving it out.
4. Number them `TC-<req>.<n>`, for example `TC-004.1`, `TC-004.2`. Each case states its preconditions, steps, test data, and an **expected result that can be checked** (an exact status code, message, value or UI state).
5. Mark each case `Auto` (to be automated) or `Manual` (with steps a person can follow). Use `Manual` only when automation isn't practical, and say why.
6. Register the test plan in `docs/index.md`. Gate B approves the design, the contract, the test plan and the test cases together.

## 2. Automate (developer, phase 3)
1. Write an automated test for every `Auto` case **before** writing the code, with the IDs in the test name: `REQ-004 TC-004.3 rejects expired reset token`.
2. Fill in the case's **Automated test** column (`file › test name`).
3. If you find a case that isn't covered, such as an edge case or an error path you discover while coding, **add** it at the end of the file (next number, `Added by: developer`, with the reason in the revision history) and automate it. Never delete, renumber or weaken an existing case. If you think a case is wrong, raise a question.
4. Red/green failures during development are normal and are not recorded as defects.

## 3. Record a test run (reviewer in phase 4, main session or human at release)
Record a run for every PR verification and every release regression. Don't record runs during development.
1. Make sure the working tree is clean, and note the commit (`git rev-parse --short HEAD`) and the environment (OS, runtime and tool versions).
2. Run **all** commands from the stack skill (unit, integration, E2E, lint, type-check), with each test runner's own output saved.
3. Create the RUN file from `test-run-template.md`. Fill in:
   - one row per command: exact command, passed/failed/skipped counts, duration
   - **one row per test case** for the REQs in scope (and every test case for a release run): `Pass` / `Fail` / `Skipped` / `Blocked` / `Not run`, with evidence
   - for `Manual` cases, execute the steps and record what you observed
4. **Failures:** for each `Fail`, record the test name, the exact error output (trimmed to the relevant lines), and a classification:
   | Classification | Meaning | Action |
   |---|---|---|
   | Product defect | The code doesn't meet the expected result | Raise a BUG (§4) |
   | Test defect | The test or the test case is wrong | Finding in the review. If the expected result is unclear, raise a question. Never "fix" a test by weakening it |
   | Environment | Setup or infrastructure problem, unrelated to the change | Fix the environment and re-run in a new RUN. Note it in this RUN |
5. Check the exit criteria from the test plan and state **Met** or **Not met** with the reason.
6. Update the **Last result** column of each test case (`Pass (RUN-…)` or `Fail (RUN-…, BUG-…)`), and the Tests column in traceability (`12/12 pass, RUN-…`). Log `test_run_recorded`.

## 4. Defects
1. Next ID: the highest `BUG-###` in `docs/04-delivery/defects/` and traceability, plus 1. Create `BUG-###-<slug>.md` from `defect-template.md` with:
   - severity (`Blocker`, `Major`, `Minor`, `Trivial`)
   - where it was found (RUN, TC, REQ, commit, environment)
   - **steps to reproduce**, expected vs actual result, and evidence (error output, screenshot path)
2. Add a traceability row for the BUG (status `Proposed`) and log `defect_raised`. A BUG in the PR under review blocks it: the verdict is Changes requested.
3. **Fix (developer):** the failing test that reproduces the bug must already exist. If the bug wasn't covered by a TC, add one first. Record the root cause and the fix commit or PR in the defect file.
4. **Verify (reviewer):** in a new RUN, confirm the TC passes, record `Verified in RUN-…`, set the status to `Verified`, then `Closed` once the PR is merged. Log `defect_closed`.
5. Defects are never deleted. Rejected or duplicate defects keep their file, with status `Rejected` or `Duplicate of BUG-…` and the reason.

## 5. Release regression
Before a release, run §3 with scope `release-<version>` on the release commit, covering **every** test case of every `Done` REQ. Release only if the exit criteria are met and no `Blocker` or `Major` BUG is open. Link the RUN in the CHANGELOG release heading.
