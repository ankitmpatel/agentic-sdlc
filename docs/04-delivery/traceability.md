# Traceability Matrix and Status Board

One row per requirement (`REQ`) or defect (`BUG`). This is the single place to see where every item stands and to trace it from source to tests.

Status: `Proposed` → `Approved` → `In Design` → `Ready` → `In Progress` → `In Review` → `Done`. Side states: `Blocked`, `Deferred`, `Rejected`.

| ID | Title | Priority | Sources | Spec | Design / contract | Code | Tests | PR | Status | Updated |
|---|---|---|---|---|---|---|---|---|---|---|
| REQ-001 | Lean agent roster | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/framework/claude/agents/, templates/brownfield/framework/ | 4/4 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| REQ-002 | Valid, non-duplicated skills | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/framework/claude/skills/ | 4/5 pass, 1 skipped, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| REQ-003 | Multi-channel requirement intake | Must | SRC-001, SRC-002 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | skills/intake-requirement/, templates/project/requirements/ | 5/5 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-13 |
| REQ-004 | Document versioning | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §4, skill templates, templates/project/docs/index.md | 3/3 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| REQ-005 | Development process tracking | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §2–5, templates/project/tracking/ | 2/2 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| REQ-006 | Ask-when-in-doubt protocol | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §6, agent files | 2/2 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| REQ-007 | Safe, tested installer | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | agent-setup.sh, templates/project/claude/settings.json | 13/13 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-12 |
| BUG-001 | Re-run re-creates deleted stack skills | Minor | [defect](defects/BUG-001-rerun-recreates-stack-skills.md) | PRD-v1.0 AC-007.6 | n/a | agent-setup.sh (HAS_STACK_SKILL) | TC-007.11 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-13 |
| REQ-008 | Documented test management | Must | SRC-003 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/framework/claude/skills/manage-tests/, templates/AGENTS.core.md §2–8 | 5/5 pass, RUN-20261113-0251-REQ-001-branch | — | In Review | 2026-11-13 |
