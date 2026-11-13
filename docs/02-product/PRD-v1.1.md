---
doc_id: PRD
title: Product Requirements — agentic-sdlc framework v2
version: 1.1
status: Approved
owner: Project owner
created: 2026-11-12
updated: 2026-11-13
approved_by: Project owner
approved_on: 2026-11-13
supersedes: PRD-v1.0.md
brd:
sources: [SRC-001, SRC-002, SRC-003, SRC-006, SRC-007]
---

# Product Requirements — agentic-sdlc framework v2

## Revision history
| Version | Date | Author | Change | Reason |
|---|---|---|---|---|
| 1.0 | 2026-11-12 | main session (Claude) | Initial draft, written alongside the implementation at the owner's direct request in chat | SRC-001, DEC-001 |
| 1.0 | 2026-11-13 | main session (Claude) | Added AC-003.4 (raw sources committed verbatim) and AC-007.6 (deleted stack skills stay deleted) | SRC-002, Q-001, DEC-002, BUG-001 |
| 1.0 | 2026-11-13 | main session (Claude) | Added REQ-008 (test management) and AC-007.7 | SRC-003 |
| 1.0 | 2026-11-13 | Project owner | Approved | SRC-004 |
| 1.1 | 2026-11-13 | main session (Claude) | Added REQ-009 (all setup through the installer); open questions updated to answered | SRC-006, SRC-007, SRC-005 |
| 1.1 | 2026-11-13 | Project owner | Approved before build ("Approve and build now") | SRC-007 |

## 1. Overview
A leaner agent roster with valid Claude Code skills, plus a fully tracked, gated development process: requirement intake from any channel, versioned documents, traceability, and a question protocol. It ships through `agent-setup.sh`, which can be re-run safely. No BRD exists for this repo; the business goal is stated in SRC-001.

## 2. Personas
| Persona | Description | Primary goals |
|---|---|---|
| Owner | Solo developer or lead who uses Claude agents for development | Less setup noise, a full audit trail, no silent assumptions |

## 3. Scope of this version
**In scope:** REQ-001 … REQ-009
**Out of scope:** automatic import from email or chat services (input arrives by paste or file drop), git operations and GitHub settings in the target project (DEC-004), release automation.

## 4. Requirements

### REQ-001 — Lean agent roster
- **Story:** As the owner, I want a few agents with clear ownership so that I know which one to use and they don't overlap.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-001.1** Given a new project install, when I list `.claude/agents/`, then exactly `planner`, `developer` and `reviewer` exist.
  - **AC-001.2** Given an existing-project install, then `onboarding` also exists.
  - **AC-001.3** Given any installed agent, its frontmatter `name` matches its file name and it has a description.

### REQ-002 — Valid, non-duplicated skills
- **Story:** As the owner, I want skills that Claude Code actually loads and that add content the agents don't already have.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-002.1** Every skill is installed as `.claude/skills/<name>/SKILL.md`, and its frontmatter `name` equals `<name>`.
  - **AC-002.2** Every core skill an agent names is installed.
  - **AC-002.3** The skills include real templates: BRD, PRD, source record, change request, technical design, OpenAPI contract, ADR.

### REQ-003 — Multi-channel requirement intake
- **Story:** As the owner, I want every email, chat, document or meeting that carries requirements recorded with an ID, date and sender, so that each requirement traces back to where it came from.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-003.1** An install provides `requirements/register.md`, `requirements/inbox/`, `requirements/sources/` and `requirements/changes/`.
  - **AC-003.2** The `intake-requirement` skill defines SRC records with channel, sender, original date, reference, verbatim content and redaction rules.
  - **AC-003.3** Changes to approved requirements produce a `CR-###` that needs a human decision.
  - **AC-003.4** Raw sources and their original files are committed to git verbatim. Only credentials and payment card numbers are redacted, and no installed file git-ignores them (SRC-002).

### REQ-004 — Document versioning
- **Story:** As the owner, I want every specification versioned with status, approval and revision history, so that approved documents are never silently changed.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-004.1** `AGENTS.md` defines the standard header, the status flow, the freeze-on-approval rule and the minor/major bump rules.
  - **AC-004.2** All spec templates contain the header and a revision-history table.
  - **AC-004.3** An install provides `docs/index.md` as the document register.

### REQ-005 — Development process tracking
- **Story:** As the owner, I want to see where every requirement stands and what happened when.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-005.1** An install provides the traceability/status board, the questions log, the decision log, a progress template, the activity ledger and the CHANGELOG.
  - **AC-005.2** `AGENTS.md` defines the lifecycle with gates A/B/C, the ID scheme, the ledger schema and its event names.

### REQ-006 — Ask-when-in-doubt protocol
- **Story:** As the owner, I want agents to ask rather than guess when something is unclear.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-006.1** `AGENTS.md` lists the triggers for asking and the procedure, including the subagent case (the subagent cannot prompt the user, so it returns its questions and the main session asks).
  - **AC-006.2** Every agent's instructions end with a "Questions for the human" output.

### REQ-007 — Safe, tested installer
- **Story:** As the owner, I want to re-run the installer to upgrade without losing tracking data or customizations.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-001 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-007.1** Re-running keeps the activity ledger, traceability, customized stack skills and `CLAUDE.md`.
  - **AC-007.2** A changed framework file is backed up before it is replaced.
  - **AC-007.3** Files from the previous framework version are reported, not deleted.
  - **AC-007.4** `--type new|existing` allows non-interactive runs, and invalid input exits non-zero.
  - **AC-007.5** `.claude/settings.json` denies `gh pr merge`, pushes to main/master, and force-pushes.
  - **AC-007.6** A stack skill the user deleted is not re-created when the installer runs again (BUG-001).
  - **AC-007.7** A new install creates a `CLAUDE.md` that imports `AGENTS.md`.

### REQ-008 — Documented test management
- **Story:** As the owner, I want every function tested, with test cases, failure cases and test results documented, so that I can see what was tested, what failed and how it was fixed.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-003 · **Status:** Approved (built; PR In Review)
- **Acceptance criteria:**
  - **AC-008.1** An install provides a `manage-tests` skill with test-plan, test-case, test-run and defect templates.
  - **AC-008.2** The rules require at least one positive and one failure test case per acceptance criterion (or a written N/A reason). Each test case is automated with its ID in the test name, or manual with steps.
  - **AC-008.3** Every verification and release run is recorded as a `RUN` report with a result per test case. Every failure is classified, and every product failure becomes a `BUG` record with reproduction steps, expected vs actual, evidence, root cause, fix and verification.
  - **AC-008.4** An install provides `docs/04-delivery/test-cases/`, `test-runs/` and `defects/`, and re-running keeps their contents.

### REQ-009 — All setup through the installer
- **Story:** As the owner, I want `agent-setup.sh` to do every setup step for new and existing projects, so that nothing has to be set up by hand after it runs.
- **Type:** Functional · **Priority:** Must · **Sources:** SRC-006, SRC-007 · **Status:** Approved
- **Acceptance criteria:**
  - **AC-009.1** An interactive install asks for the stack (Node/Express, React, both, other), and `--stack node-express|react|both|other` sets it non-interactively. Only the chosen stack skills are installed. "Other" installs a blank `stack-project` template. Without a terminal and without `--stack`, the blank template is installed.
  - **AC-009.2** When a `stack-*` skill already exists and no `--stack` is given, the installer neither asks nor adds stack skills. An invalid `--stack` value exits non-zero before anything is installed.
  - **AC-009.3** Files from the previous framework version are removed only with `--remove-legacy` or a "y" answer to the prompt. Otherwise they are listed. No other file is ever removed.
  - **AC-009.4** New projects get placeholder files in `src/backend`, `src/frontend`, `tests/backend` and `tests/e2e`, so git keeps the scaffold.
  - **AC-009.5** The installer records the framework version, project type and stacks in `.claude/sdlc.json` and appends a `framework_installed` (first run) or `framework_upgraded` event to `tracking/activity.jsonl`. A re-run without `--type` uses the recorded type. Without a terminal, no `--type` and no record, it exits non-zero with a message.
  - **AC-009.6** The installer runs no git commands and changes no GitHub settings (DEC-004). It prints reminders to commit the installed files and to protect `main`.

## 5. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| Deny rules match command prefixes only (e.g. a plain `git push` while on `main` isn't caught) | Medium | README and installer recommend GitHub branch protection |
| Raw sources containing personal data are committed (DEC-002) | Medium | Only credentials are redacted; the README and the inbox README tell you to keep the repository private |

## 6. Open questions
| Q | Question | Affects | Blocking |
|---|---|---|---|
| Q-001 | Commit raw sources to git? Answered: yes, verbatim (SRC-002) | REQ-003 | No (Answered) |
| Q-002 | Separate QA role? Answered: no (SRC-005) | REQ-001 | No (Answered) |
| Q-003 | Human UAT sign-off before merge? Answered: optional (SRC-005) | REQ-008 | No (Answered) |
| Q-004 | Numeric code-coverage threshold? Answered: none (SRC-005) | REQ-008 | No (Answered) |
