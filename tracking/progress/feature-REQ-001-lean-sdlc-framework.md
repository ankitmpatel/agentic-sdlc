# Progress — feature/REQ-001-lean-sdlc-framework

- **Work items:** REQ-001 … REQ-009, BUG-001
- **Governing docs:** PRD-v1.1, ARCH-MAP v1.0, TEST-PLAN v1.1 (all Approved 2026-11-13; v1.1 via SRC-007)
- **Role:** main session (Claude), working directly at the owner's request
- **Started:** 2026-11-12
- **Status:** In Review
- **PR:** not yet (gh CLI not installed; compare URL to be reported)

## Plan
- [x] Move generated content from heredocs in agent-setup.sh to templates/ (REQ-007)
- [x] Agents: planner, developer, reviewer, onboarding (REQ-001, REQ-006)
- [x] Skills in `<name>/SKILL.md` format with templates (REQ-002, REQ-003, REQ-004)
- [x] Tracking files and AGENTS.md lifecycle, IDs, ledger (REQ-004, REQ-005, REQ-006)
- [x] Installer: managed vs missing-only installs, backups, legacy detection, --type, deny rules (REQ-007)
- [x] tests/setup.test.sh
- [x] Dogfood: install into this repo, remove legacy files, record SRC-001, PRD, traceability
- [x] REQ-008: manage-tests skill, rules, agents, test cases for REQ-001…008, test names carry TC-IDs
- [x] Record RUN for this branch (RUN-20261113-0251-REQ-001-branch)
- [x] Owner approves PRD-v1.0, ARCH-MAP v1.0 and TEST-PLAN v1.0 (SRC-004)
- [x] Owner answers Q-002, Q-003, Q-004 (SRC-005: defaults, DEC-003)
- [x] REQ-009: all setup through the installer (test cases first, tests red, then implementation)
- [ ] Record RUN for REQ-009
- [ ] Push branch, open PR, reviewer run, owner merges

## Log
| Date | Update |
|---|---|
| 2026-11-12 | Started. The process was not gated: the owner asked directly in chat, so the specs were written alongside the implementation and are In Review (DEC-001). |
| 2026-11-12 | Implementation complete; legacy agents and skills removed from this repo. |
| 2026-11-13 | Q-001 answered (SRC-002): raw sources committed verbatim. Updated the intake skill, AGENTS.md and the inbox README (DEC-002). |
| 2026-11-13 | BUG-001: the re-run re-created deleted stack skills. Fixed in agent-setup.sh (abcfbde), with TC-007.11 added. |
| 2026-11-13 | SRC-003 / REQ-008: test management added. Test names now carry TC-IDs; checks went from 60 to 46 because related checks were merged, with TC-002.5 and TC-007.13 added. |
| 2026-11-13 | RUN-20261113-0251-REQ-001-branch on e82e8e5: 38/39 test cases pass, 1 skipped (TC-002.3, PyYAML missing), exit criteria Met. BUG-001 Verified. |
| 2026-11-13 | Owner approved PRD-v1.0, ARCH-MAP v1.0 and TEST-PLAN v1.0 (SRC-004). Gates A and B passed after the fact. |
| 2026-11-13 | Q-002–Q-004 answered with the defaults (SRC-005, DEC-003). The approved PRD and test plan were not edited (frozen); questions.md is the record. README setup instructions updated. |
| 2026-11-13 | SRC-006/SRC-007: REQ-009 approved before build (PRD-v1.1, TEST-PLAN v1.1; v1.0 Superseded). Wrote TC-REQ-009, then the tests (red: 40 failed), then the code (green: 61 passed, 1 skipped). DEC-004: the installer never touches git or GitHub. |

## Test evidence
| Date | Command | Result |
|---|---|---|
| 2026-11-12 | `bash tests/setup.test.sh` | 54 passed, 0 failed (YAML check skipped: PyYAML not installed) |
| 2026-11-13 | `bash tests/setup.test.sh` | 60 passed, 0 failed (YAML check skipped: PyYAML not installed) |
| 2026-11-13 | `bash tests/setup.test.sh` (TC-named suite) | 46 passed, 0 failed, 1 skipped (TC-002.3: PyYAML not installed) |
| 2026-11-13 | `bash tests/setup.test.sh` before REQ-009 code | 21 passed, 40 failed, 1 skipped (expected red) |
| 2026-11-13 | `bash tests/setup.test.sh` after REQ-009 code | 61 passed, 0 failed, 1 skipped |

## Blockers and questions
- Q-001 answered (SRC-002)
- Q-002, Q-003, Q-004 answered (SRC-005)
