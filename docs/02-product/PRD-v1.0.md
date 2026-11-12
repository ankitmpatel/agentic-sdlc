---
doc_id: PRD
title: Product Requirements — agentic-sdlc framework v2
version: 1.0
status: In Review
owner: Project owner
created: 2026-11-12
updated: 2026-11-12
approved_by:
approved_on:
supersedes:
brd:
sources: [SRC-001]
---

# Product Requirements — agentic-sdlc framework v2

## Revision history
| Version | Date | Author | Change | Reason |
|---|---|---|---|---|
| 1.0 | 2026-11-12 | main session (Claude) | Initial draft, written alongside the implementation at the owner's direct request in chat | SRC-001, DEC-001 |

## 1. Overview
A leaner agent roster with valid Claude Code skills, plus a fully tracked, gated development process: requirement intake from any channel, versioned documents, traceability, and a question protocol. It ships through `agent-setup.sh`, which can be re-run safely. No BRD exists for this repo; the business goal is stated in SRC-001.

## 2. Personas
| Persona | Description | Primary goals |
|---|---|---|
| Owner | Solo developer or lead who uses Claude agents for development | Less setup noise, a full audit trail, no silent assumptions |

## 3. Scope of this version
**In scope:** REQ-001 … REQ-007
**Out of scope:** automatic import from email or chat services (input arrives by paste or file drop), GitHub branch-protection setup, release automation.

## 4. Requirements

### REQ-001 — Lean agent roster
- **Story:** As the owner, I want a few agents with clear ownership so that I know which one to use and they don't overlap.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-001.1** Given a new project install, when I list `.claude/agents/`, then exactly `planner`, `developer` and `reviewer` exist.
  - **AC-001.2** Given an existing-project install, then `onboarding` also exists.
  - **AC-001.3** Given any installed agent, its frontmatter `name` matches its file name and it has a description.

### REQ-002 — Valid, non-duplicated skills
- **Story:** As the owner, I want skills that Claude Code actually loads and that add content the agents don't already have.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-002.1** Every skill is installed as `.claude/skills/<name>/SKILL.md`, and its frontmatter `name` equals `<name>`.
  - **AC-002.2** Every core skill an agent names is installed.
  - **AC-002.3** The skills include real templates: BRD, PRD, source record, change request, technical design, OpenAPI contract, ADR.

### REQ-003 — Multi-channel requirement intake
- **Story:** As the owner, I want every email, chat, document or meeting that carries requirements recorded with an ID, date and sender, so that each requirement traces back to where it came from.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-003.1** An install provides `requirements/register.md`, `requirements/inbox/`, `requirements/sources/` and `requirements/changes/`.
  - **AC-003.2** The `intake-requirement` skill defines SRC records with channel, sender, original date, reference, verbatim content and redaction rules.
  - **AC-003.3** Changes to approved requirements produce a `CR-###` that needs a human decision.

### REQ-004 — Document versioning
- **Story:** As the owner, I want every specification versioned with status, approval and revision history, so that approved documents are never silently changed.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-004.1** `AGENTS.md` defines the standard header, the status flow, the freeze-on-approval rule and the minor/major bump rules.
  - **AC-004.2** All spec templates contain the header and a revision-history table.
  - **AC-004.3** An install provides `docs/index.md` as the document register.

### REQ-005 — Development process tracking
- **Story:** As the owner, I want to see where every requirement stands and what happened when.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-005.1** An install provides the traceability/status board, the questions log, the decision log, a progress template, the activity ledger and the CHANGELOG.
  - **AC-005.2** `AGENTS.md` defines the lifecycle with gates A/B/C, the ID scheme, the ledger schema and its event names.

### REQ-006 — Ask-when-in-doubt protocol
- **Story:** As the owner, I want agents to ask rather than guess when something is unclear.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-006.1** `AGENTS.md` lists the triggers for asking and the procedure, including the subagent case (the subagent cannot prompt the user, so it returns its questions and the main session asks).
  - **AC-006.2** Every agent's instructions end with a "Questions for the human" output.

### REQ-007 — Safe, tested installer
- **Story:** As the owner, I want to re-run the installer to upgrade without losing tracking data or customizations.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** In Review
- **Acceptance criteria:**
  - **AC-007.1** Re-running keeps the activity ledger, traceability, customized stack skills and `CLAUDE.md`.
  - **AC-007.2** A changed framework file is backed up before it is replaced.
  - **AC-007.3** Files from the previous framework version are reported, not deleted.
  - **AC-007.4** `--type new|existing` allows non-interactive runs, and invalid input exits non-zero.
  - **AC-007.5** `.claude/settings.json` denies `gh pr merge`, pushes to main/master, and force-pushes.

## 5. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| Deny rules match command prefixes only (e.g. a plain `git push` while on `main` isn't caught) | Medium | README and installer recommend GitHub branch protection |
| Raw sources may contain personal data | Medium | Redaction rules in the intake skill, privacy note in the inbox README, Q-001 |

## 6. Open questions
| Q | Question | Affects | Blocking |
|---|---|---|---|
| Q-001 | Commit raw sources to git? | REQ-003 | No (Assumed) |
| Q-002 | Separate QA role? | REQ-001 | No (Assumed) |
