---
doc_id: TC-REQ-007
title: Test cases — REQ-007 Safe, tested installer
req: REQ-007
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-007 Safe, tested installer

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-007.1 | AC-007.4 | Positive | `--type new` runs non-interactively and scaffolds src/tests | Empty folder | `bash agent-setup.sh --type new` | Exit 0; src/backend, src/frontend, tests/backend, tests/e2e exist | Auto | `tests/setup.test.sh › "TC-007.1 --type new runs non-interactively and exits 0"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.2 | AC-007.4 | Positive | `--type existing` adds guardrails and onboarding docs; new projects don't get them | Folder with code | `--type existing` | Exit 0; guardrails in AGENTS.md; `docs/00-onboarding/` | Auto | `tests/setup.test.sh › "TC-007.2 brownfield guardrails and docs/00-onboarding added"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.3 | AC-007.4 | Negative | Existing install doesn't scaffold or touch source | `src/app.js` = "keep me" | `--type existing` | File unchanged; no `src/backend` | Auto | `tests/setup.test.sh › "TC-007.3 existing source untouched and no src/backend scaffold"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.4 | AC-007.1 | Positive | Re-run keeps ledger, traceability, customized stack skill and CLAUDE.md | Installed project with added data | Re-run installer | All data still present | Auto | `tests/setup.test.sh › "TC-007.4 activity ledger and traceability rows kept"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.5 | AC-007.2 | Positive | Changed framework file restored and backed up | AGENTS.md edited locally | Re-run | Template content restored; `AGENTS.md.bak-*` holds the edit | Auto | `tests/setup.test.sh › "TC-007.5 changed AGENTS.md restored and the local copy backed up"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.13 | AC-007.2 | Negative | Unchanged files are not backed up | Fresh existing install | Re-run with no changes | No `*.bak-*` files | Auto | `tests/setup.test.sh › "TC-007.13 unchanged framework files are not backed up"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.6 | AC-007.3 | Positive | Legacy files reported, not deleted | `pm.md`, `create-prd.md` present | Install | Warning printed; files still exist | Auto | `tests/setup.test.sh › "TC-007.6 legacy files reported, not deleted"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.7 | AC-007.4 | Negative | Unknown `--type` rejected | — | `--type nonsense` | Non-zero exit | Auto | `tests/setup.test.sh › "TC-007.7 unknown --type rejected with non-zero exit"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.8 | AC-007.4 | Negative | Unknown option, or `--type` without a value, rejected | — | `--bogus`; `--type` | Non-zero exit | Auto | `tests/setup.test.sh › "TC-007.8 unknown option rejected with non-zero exit"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.9 | AC-007.4 | Positive | `--help` prints usage | — | `--help` | Exit 0; "Usage:" printed | Auto | `tests/setup.test.sh › "TC-007.9 --help exits 0 and prints usage"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.10 | AC-007.5 | Positive | settings.json valid and denies merge | New install | Parse JSON; grep | Valid; contains `gh pr merge` | Auto | `tests/setup.test.sh › "TC-007.10 settings.json is valid JSON and denies gh pr merge"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| — | AC-007.5 | Negative | N/A here — deny rules are enforced by Claude Code, not the installer; prefix-only matching is a documented risk in PRD-v1.0 §5 |  |  |  |  |  | — |
| TC-007.11 | AC-007.6 | Negative | Deleted stack skill not re-created (BUG-001) | `stack-node-express` deleted | Re-run | Folder still absent | Auto | `tests/setup.test.sh › "TC-007.11 deleted stack skill is not re-created (BUG-001)"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-007.12 | AC-007.7 | Positive | CLAUDE.md imports AGENTS.md | New install | grep CLAUDE.md | First line `@AGENTS.md` | Auto | `tests/setup.test.sh › "TC-007.12 CLAUDE.md imports AGENTS.md"` | Pass (RUN-20261113-0331-REQ-009-branch) |
