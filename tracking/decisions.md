# Decision Log

Product, scope, priority and process decisions. Architecture decisions go in `docs/03-architecture/adr/`. Decisions are never edited after the fact; a reversal is a new entry that references the old one.

<!-- Copy this block for each decision, newest at the bottom.

## DEC-001 — <short title>
- **Date:** YYYY-MM-DD
- **Decided by:** <human name / role>
- **Related:** REQ-000, CR-000, Q-000, SRC-000
- **Context:** <what prompted the decision>
- **Decision:** <what was decided>
- **Consequences:** <what changes as a result>
- **Supersedes:** <DEC-000 or none>
-->

## DEC-001 — Adopt the lean agent roster
- **Date:** 2026-11-12
- **Decided by:** Project owner
- **Related:** SRC-001, REQ-001, REQ-002
- **Context:** Six role agents and nine flat skills overlapped heavily, and the skills weren't loaded by Claude Code at all (wrong folder format).
- **Decision:** Replace them with planner, developer and reviewer (plus onboarding for existing projects), and five core skills plus editable stack skills, keeping the full gated process.
- **Consequences:** The PM and architect roles merge into planner; backend, UI and QA merge into developer, with reviewer verification. Previous files are reported by the installer for removal.
- **Supersedes:** none
