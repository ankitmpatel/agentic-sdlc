---
name: implement-feature
description: Test-first implementation of an approved REQ-ID or a BUG-ID against the approved API contract — branch, progress file, failing tests named after the REQ, minimal code, full test run with recorded evidence, traceability and CHANGELOG updates, PR. Use for any code change.
---
# Implement a feature or fix

Use the project's `stack-*` skill for the actual commands and conventions.

## 1. Gate check (stop if any fails)
- [ ] The traceability row shows `Ready` (or `Approved` when the design says no technical design is needed). For a BUG, the row exists.
- [ ] The REQ's PRD version is `Approved`. For API work, the contract version is `Approved` and lists the REQ in `x-req-ids`.
- [ ] Test cases exist in `docs/04-delivery/test-cases/TC-REQ-###.md`, with positive and failure cases for every AC. A BUG has its defect file in `docs/04-delivery/defects/`.
- [ ] No open blocking question references the item.

If a check fails, report the missing gate and ask. Do not start.

## 2. Set up
1. `git checkout main && git pull` (when a remote exists), then `git checkout -b feature/REQ-###-<slug>` (or `fix/BUG-###-<slug>`).
2. Copy `tracking/progress/_template.md` to `tracking/progress/<branch-with-dashes>.md` and fill in the work items, the plan (one checkbox per acceptance criterion), and the start date.
3. Set the traceability status to `In Progress`. Log `task_started` and `status_changed`.

## 3. Tests first
1. Open the REQ's test-case file. For **every** `Auto` test case, positive and failure cases alike, write the test **before** the code, with the IDs in its name: `REQ-004 TC-004.3 rejects expired reset token`. Fill in the case's Automated test column (`manage-tests` §2).
2. Put each test at the level the technical design's testing strategy names: unit, integration, or E2E. E2E tests select elements by `data-testid` and live in a file named after the REQ.
3. Found an uncovered case (an edge case or error path)? Add it as a new TC at the bottom of the file and automate it. Never delete, renumber or weaken an existing case.
4. **Bugs:** first write the test for the defect's TC (add a TC if none covers it), run it, and confirm it fails the way the defect file describes. Fill in the defect's Root cause and Fix sections when you're done.
5. Run the new tests and confirm they fail for the expected reason. Record this in the progress file.

## 4. Implement
- Write the minimum code that satisfies the acceptance criteria and the contract **exactly**: paths, field names, types, status codes and error schema.
- If the contract or design turns out to be wrong or incomplete, **stop**. Raise a question or tell the planner a CR is needed. Do not change the contract or quietly work around it.
- Existing projects: follow `AGENTS.md` §10. Add new files, and touch existing files only to wire things up. Add characterization tests before changing an existing file.
- Give interactive UI elements a `data-testid`, and keep them accessible (labels, roles, keyboard support).
- No secrets in code. Read configuration from the environment.

## 5. Verify
1. Run the **full** relevant suites: unit, integration, E2E, lint, and type-check, using the stack skill's commands.
2. Record each command and its result (pass/fail counts) in the progress file's "Test evidence" table, and log `tests_run`.
3. If anything fails, fix the code, or ask if the test itself looks wrong. Never skip, weaken or delete a test to make it pass.

## 6. Record
1. **Traceability row:** Code (main files), Tests (test files), PR, and status `In Review`.
2. **CHANGELOG.md:** under `## [Unreleased]`, add a line in the right section (`Added`, `Changed`, `Fixed`, `Removed`, `Security`), for example `- Password reset by email (REQ-004)`.
3. **Progress file:** tick the plan items, add a log entry, and set the status to `In Review`.
4. Log `status_changed` and `task_done`.

## 7. Commit and PR
- Commit in logical steps (tests, then implementation), using `type(ID): summary` messages.
- `git push -u origin <branch>`, then `gh pr create --title "feat(REQ-004): password reset" --body-file <file>` with this body:

```markdown
## Work items
REQ-004 (PRD-v1.1), contract api-contract-v1.1.yaml

## Summary
<what changed and why>

## Test cases → tests
| TC | AC | Type | Test |
|---|---|---|---|
| TC-004.1 | AC-004.1 | Positive | tests/backend/reset.test.ts › "REQ-004 TC-004.1 ..." |
| TC-004.2 | AC-004.1 | Negative | tests/backend/reset.test.ts › "REQ-004 TC-004.2 ..." |

Test cases added during development: <TC-IDs or none>

## Test evidence
| Command | Result |
|---|---|
| npm test | 48 passed, 0 failed |

## Tracking
- [x] traceability.md  - [x] progress file  - [x] activity.jsonl  - [x] CHANGELOG.md

## Open questions
none
```

Log `pr_opened`. If `gh` is unavailable, report `https://github.com/<owner>/<repo>/compare/<branch>?expand=1`.
