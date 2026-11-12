---
name: review-pr
description: Independent verification of a pull request or branch — traceability of IDs, document versioning, scope, acceptance criteria to test mapping, running the tests, code quality and security, tracking files — producing a written review report with a verdict of Changes requested or Ready for human. Use whenever a PR or branch needs review.
---
# Review a PR

**Verify, don't trust.** Read the tests rather than their names. Run the commands rather than reading claimed results.

## 1. Gather
- The diff: `gh pr diff <n>` and `gh pr view <n>`, or `git diff main...<branch>` without `gh`
- The IDs referenced in the title, commits and body
- The governing documents for those IDs: PRD, design and contract versions, from `docs/index.md`
- The progress file and traceability rows for those IDs

## 2. Checklist
Record each item as ✅, ❌ (finding) or N/A.

**A. Traceability**
- The PR title and every commit reference a valid ID that exists in the PRD or traceability
- The traceability row has Code, Tests and PR filled in, and its status is `In Review`
- Every ID in the diff is covered by the PR, so no work is untracked

**B. Gates and scope**
- The REQ was `Ready` (or `Approved`) before work started (check `tracking/activity.jsonl`)
- The diff changes only what the REQ needs: no unrelated refactors, and no changes to approved docs or contracts
- Existing projects: the `AGENTS.md` §10 guardrails are followed (new files, characterization tests)

**C. Requirements coverage**
- Every acceptance criterion of every REQ in the PR has a test that actually asserts the stated behavior
- Implemented paths, fields, status codes and errors match the approved contract exactly
- Edge and error cases in the acceptance criteria are tested, not just the happy path

**D. Tests (run them yourself)**
- Run the stack skill's commands for unit, integration, E2E, lint and type-check. Record each exact command and its result.
- No skipped, weakened or deleted tests (search the diff for `skip`, `only`, `xit` and removed assertions)

**E. Code quality and security**
- Correctness, including null and empty input, concurrency and error paths
- Input validation, authorization checks, no secrets or personal data in code or logs, safe queries
- `data-testid` on interactive elements, plus labels and keyboard access
- Readable, consistent with existing patterns, no dead code

**F. Documents and versioning**
- Changed specs have a valid header, a revision row with a reason, and the correct version bump
- No `Approved` file was modified
- `docs/index.md` matches the files

**G. Tracking**
- The progress file has test evidence, the activity ledger has the events, and CHANGELOG has an `[Unreleased]` entry
- The questions raised are resolved or listed in the PR

## 3. Report
Write `docs/04-delivery/reviews/REV-<PR number or branch>-<YYYY-MM-DD>.md`:

```markdown
# Review — PR #<n> <title>
- Date: YYYY-MM-DD · Reviewer: reviewer (agent) · Commit: <sha>
- Items: REQ-…, governing docs: PRD-vX.Y, api-contract-vX.Y
- **Verdict: Changes requested | Ready for human**

## Test runs
| Command | Result |
|---|---|

## Findings
| # | Severity | File:line | Finding | Suggested fix |
|---|---|---|---|---|

## Checklist
A ✅ · B ✅ · C ❌ (#1) · D ✅ · E ✅ · F N/A · G ✅
```

The verdict is **Changes requested** if there is any Blocker or Major finding, or any acceptance criterion without a real test. Otherwise it is **Ready for human**.

## 4. Publish
- With `gh`: `gh pr review <n> --request-changes --body-file <report>` for Changes requested, or `gh pr review <n> --comment --body-file <report>` for Ready for human. **Never `--approve`. Never merge.**
- Without `gh`: commit the report to the PR branch (`docs(REQ-…): review report`) and push.
- Log `review_done` with the verdict in `note`.
