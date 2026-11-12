# Progress — feature/REQ-001-lean-sdlc-framework

- **Work items:** REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-006, REQ-007
- **Governing docs:** PRD-v1.0 (In Review), ARCH-MAP v1.0 (In Review)
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
- [ ] Owner approves PRD-v1.0 and ARCH-MAP v1.0; answers Q-001 and Q-002

## Log
| Date | Update |
|---|---|
| 2026-11-12 | Started. The process was not gated: the owner asked directly in chat, so the specs were written alongside the implementation and are In Review (DEC-001). |
| 2026-11-12 | Implementation complete; legacy agents and skills removed from this repo. |

## Test evidence
| Date | Command | Result |
|---|---|---|
| 2026-11-12 | `bash tests/setup.test.sh` | 54 passed, 0 failed (YAML check skipped: PyYAML not installed) |

## Blockers and questions
- Q-001, Q-002 (non-blocking, Assumed)
