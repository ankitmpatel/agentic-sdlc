# Progress — feature/REQ-001-lean-sdlc-framework

- **Work items:** REQ-001 … REQ-008, BUG-001
- **Governing docs:** PRD-v1.0, ARCH-MAP v1.0, TEST-PLAN v1.0 (all In Review)
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
- [ ] Record RUN for this branch
- [ ] Owner approves PRD-v1.0, ARCH-MAP v1.0 and TEST-PLAN v1.0; answers Q-002, Q-003, Q-004

## Log
| Date | Update |
|---|---|
| 2026-11-12 | Started. The process was not gated: the owner asked directly in chat, so the specs were written alongside the implementation and are In Review (DEC-001). |
| 2026-11-12 | Implementation complete; legacy agents and skills removed from this repo. |
| 2026-11-13 | Q-001 answered (SRC-002): raw sources committed verbatim. Updated the intake skill, AGENTS.md and the inbox README (DEC-002). |
| 2026-11-13 | BUG-001: the re-run re-created deleted stack skills. Fixed in agent-setup.sh (abcfbde), with TC-007.11 added. |
| 2026-11-13 | SRC-003 / REQ-008: test management added. Test names now carry TC-IDs; checks went from 60 to 46 because related checks were merged, with TC-002.5 and TC-007.13 added. |

## Test evidence
| Date | Command | Result |
|---|---|---|
| 2026-11-12 | `bash tests/setup.test.sh` | 54 passed, 0 failed (YAML check skipped: PyYAML not installed) |
| 2026-11-13 | `bash tests/setup.test.sh` | 60 passed, 0 failed (YAML check skipped: PyYAML not installed) |
| 2026-11-13 | `bash tests/setup.test.sh` (TC-named suite) | 46 passed, 0 failed, 1 skipped (TC-002.3: PyYAML not installed) |

## Blockers and questions
- Q-001 answered (SRC-002)
- Q-002, Q-003, Q-004 (non-blocking, Assumed)
