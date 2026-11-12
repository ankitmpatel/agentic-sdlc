# Traceability Matrix and Status Board

One row per requirement (`REQ`) or defect (`BUG`). This is the single place to see where every item stands and to trace it from source to tests.

Status: `Proposed` → `Approved` → `In Design` → `Ready` → `In Progress` → `In Review` → `Done`. Side states: `Blocked`, `Deferred`, `Rejected`.

| ID | Title | Priority | Sources | Spec | Design / contract | Code | Tests | PR | Status | Updated |
|---|---|---|---|---|---|---|---|---|---|---|
| REQ-001 | Lean agent roster | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/framework/claude/agents/, templates/brownfield/framework/ | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-002 | Valid, non-duplicated skills | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/framework/claude/skills/ | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-003 | Multi-channel requirement intake | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | skills/intake-requirement/, templates/project/requirements/ | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-004 | Document versioning | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §4, skill templates, templates/project/docs/index.md | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-005 | Development process tracking | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §2–5, templates/project/tracking/ | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-006 | Ask-when-in-doubt protocol | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | templates/AGENTS.core.md §6, agent files | tests/setup.test.sh | — | In Review | 2026-11-12 |
| REQ-007 | Safe, tested installer | Must | SRC-001 | PRD-v1.0 | n/a (installer, see ARCH-MAP v1.0) | agent-setup.sh, templates/project/claude/settings.json | tests/setup.test.sh | — | In Review | 2026-11-12 |
