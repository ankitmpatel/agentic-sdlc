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

## DEC-002 — Raw requirement sources are committed verbatim
- **Date:** 2026-11-13
- **Decided by:** Project owner
- **Related:** Q-001, SRC-002, REQ-003
- **Context:** Raw emails and chats can contain personal data; Q-001 asked whether they belong in git.
- **Decision:** Commit raw emails, chats and documents, and their original files, verbatim, with headers, names, signatures and quoted replies kept. Credentials and payment card numbers are still redacted as `[REDACTED: <type>]`.
- **Consequences:** The repository holds personal data and should stay private. The intake skill, AGENTS.md §8 and the inbox README were updated; tests assert the rule.
- **Supersedes:** none
