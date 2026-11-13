# Agent Rules

These rules apply to every agent and to the main Claude session. **Repository files are the source of truth, not chat history.** If something isn't written in the repo, it didn't happen.

## 1. Roles

| Role | Definition | Owns |
|---|---|---|
| Planner | `.claude/agents/planner.md` | Requirement intake, BRD, PRD, technical design, API contract, change requests |
| Developer | `.claude/agents/developer.md` | Code, unit/integration/E2E tests, traceability updates, CHANGELOG entries |
| Reviewer | `.claude/agents/reviewer.md` | Independent verification and PR review. Never edits code or specs |
| Onboarding (existing projects) | `.claude/agents/onboarding.md` | As-built documentation of an existing codebase |
| **Human** | — | Approves documents, answers questions, accepts change requests, merges PRs, cuts releases |

## 2. Lifecycle and gates

```
0 Intake ─► 1 Requirements ─► [Gate A] ─► 2 Design ─► [Gate B] ─► 3 Build ─► 4 Verify ─► 5 Review ─► [Gate C] ─► 6 Release
 planner      planner          human       planner      human      developer   developer   reviewer     human       human
```

- **Gate A:** the human approves the PRD (its REQs become `Approved`).
- **Gate B:** the human approves the technical design and API contract (REQs become `Ready`).
- **Gate C:** the human merges the PR after the reviewer reports "Ready for human".
- Do not start a phase whose gate has not passed. If you are asked to, say which gate is missing and ask.
- **Defects** (`BUG-###`) skip phases 1–2: record the bug, reproduce it with a failing test, fix it, then review.
- **Changes to approved work** go through a change request (`CR-###`) and a new document version. They never edit approved files.

## 3. IDs

| Prefix | Meaning | Defined in |
|---|---|---|
| `SRC-001` | A requirement source: email, chat, document, meeting, call, ticket | `requirements/register.md` + `requirements/sources/` |
| `REQ-001` | A requirement or user story (functional or non-functional) | PRD |
| `AC-001.1` | An acceptance criterion of REQ-001 | PRD |
| `BUG-001` | A defect | `docs/04-delivery/traceability.md` |
| `CR-001` | A change request against an approved document | `requirements/changes/` |
| `Q-001` | An open question or an assumption that needs confirmation | `tracking/questions.md` |
| `DEC-001` | A product, scope or process decision | `tracking/decisions.md` |
| `ADR-001` | An architecture decision | `docs/03-architecture/adr/` |

IDs are never reused or renumbered. To get the next one, find the highest existing number and add 1, for example: `grep -rhoE 'REQ-[0-9]{3}' docs requirements tracking | sort -u | tail -1`.

## 4. Document versioning

Applies to specs: BRD, PRD, technical design, API contract, as-built docs.

1. File names carry the version: `PRD-v1.0.md`, `tech-design-v1.1.md`, `api-contract-v2.0.yaml`.
2. Every spec starts with the standard header and revision history below.
3. Status flow: `Draft` → `In Review` → `Approved` → `Superseded`.
4. **Only the human approves.** When the human explicitly approves a document, set `status: Approved`, `approved_by`, `approved_on`, and log a `doc_approved` event. Never infer approval.
5. While `Draft` or `In Review`, edit the file in place and add a revision-history row for each change.
6. **An `Approved` file is frozen.** To change it, copy it to the next version and set the copy to `Draft` with `supersedes:` pointing to the old file. Use a **minor** bump (1.0 → 1.1) for additions or clarifications and a **major** bump (1.x → 2.0) for removed or changed scope. Mark the old file `Superseded` only when the new one is approved.
7. Every revision row names its reason: a `SRC`, `CR` or `Q` ID.
8. `docs/index.md` lists each document's current version and status. Update it whenever a version or status changes.
9. Living logs (register, traceability, questions, decisions, progress files) are edited in place, and git history is their version history. `tracking/activity.jsonl` is append-only.

Standard header:

```markdown
---
doc_id: PRD
title: Product Requirements
version: 1.0
status: Draft
owner: <human owner>
created: YYYY-MM-DD
updated: YYYY-MM-DD
approved_by:
approved_on:
supersedes:
sources: [SRC-001]
---

## Revision history
| Version | Date | Author | Change | Reason |
|---|---|---|---|---|
| 1.0 | YYYY-MM-DD | planner (agent) | Initial draft | SRC-001 |
```

## 5. Tracking

| File | Purpose | Who updates |
|---|---|---|
| `requirements/register.md` | Every requirement source ever received | planner |
| `docs/04-delivery/traceability.md` | **Status board**: one row per REQ/BUG with its source → spec → design → code → tests → PR | everyone |
| `docs/index.md` | Document register: current version and status of every spec | planner, onboarding |
| `tracking/questions.md` | Open questions and assumptions | everyone |
| `tracking/decisions.md` | Product, scope and process decisions | planner |
| `tracking/progress/<branch>.md` | Plan, log and test evidence for one branch (`/` in the branch name becomes `-`) | the agent working on the branch |
| `tracking/activity.jsonl` | Append-only event ledger | everyone |
| `CHANGELOG.md` | User-visible changes ([Keep a Changelog](https://keepachangelog.com) format) | developer |

Status values for REQ/BUG rows: `Proposed` → `Approved` → `In Design` → `Ready` → `In Progress` → `In Review` → `Done`. Side states: `Blocked`, `Deferred`, `Rejected`.

Copy new progress files from `tracking/progress/_template.md`.

**Activity ledger.** Append one JSON object per line for every event:

```bash
echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"actor\":\"developer\",\"event\":\"status_changed\",\"ref\":\"REQ-003\",\"from\":\"Ready\",\"to\":\"In Progress\",\"branch\":\"feature/REQ-003-login\",\"note\":\"\"}" >> tracking/activity.jsonl
```

Fields: `ts`, `actor` (planner, developer, reviewer, onboarding, human, main), `event`, `ref` (an ID or a file), optional `from`, `to`, `branch`, `note`.
Events: `source_captured`, `req_created`, `status_changed`, `doc_created`, `doc_versioned`, `doc_approved`, `cr_raised`, `cr_decided`, `question_raised`, `question_answered`, `decision_recorded`, `task_started`, `task_blocked`, `task_done`, `tests_run`, `pr_opened`, `review_done`.

## 6. Ask, don't assume

**Stop and ask** when:
- a requirement is ambiguous, incomplete, or has no testable acceptance criteria
- two sources conflict, or a new source conflicts with an approved document
- a choice has product, cost, security, privacy, data or UX impact
- the work needs a change to an approved document, the API contract, or anything outside the task
- tests, code and requirements disagree and it is unclear which is right

**How to ask:**
1. Add each question to `tracking/questions.md` with its context, the options (your recommendation first), and whether it blocks work.
2. If it blocks work, set the affected REQ/BUG to `Blocked` and log `question_raised`.
3. If you can talk to the human directly (main session), ask now. If you are a subagent, you cannot, so end your run with a **"Questions for the human"** section listing each Q-ID with its options. Keep working only on items that are not blocked.
4. For an unknown that doesn't block work, you may proceed on a stated assumption. Record it as a question with `Status: Assumed` so the human confirms it later.
5. When an answer arrives, record the answer, who gave it, when, and through which channel. If it came by email, chat or a document, also capture it as a source (`SRC`). Then unblock the item.

**Main session:** when a subagent returns questions, ask the human (in one batch) before starting the next phase.

## 7. Git and pull requests

- One branch per work item: `feature/REQ-012-short-name`, `fix/BUG-003-short-name`, `docs/PRD-v1.1`.
- Commit messages: `type(ID): summary`. Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`. Example: `feat(REQ-012): add password reset endpoint`.
- PR titles include the IDs. PR bodies list: the IDs, a summary, documents changed (with versions), tests run with results, and open questions.
- **Never merge. Never push to `main`. Never force-push.** `.claude/settings.json` blocks the common forms of these commands; GitHub branch protection is the real safeguard.
- If `gh` is unavailable, push the branch and report the compare URL so the human can open the PR.

## 8. Quality gates

- No code without an `Approved` REQ, and for API work an `Approved` contract.
- Every acceptance criterion maps to at least one test, and test names include the REQ-ID.
- Interactive UI elements have a `data-testid`.
- Run the tests and report the exact command and result. Never weaken, skip or delete a test to make it pass.
- No secrets or credentials (passwords, API keys, tokens, payment card numbers) anywhere in the repository. Redact them from captured sources as `[REDACTED: <type>]`.
- Raw requirement sources (emails, chats, documents) are **committed verbatim** under `requirements/sources/`, including names and contact details, because they are the audit trail. Keep personal data out of code, test fixtures and logs.

## 9. Skills

Skills live in `.claude/skills/<name>/SKILL.md` and load on demand.

| Skill | Used by | For |
|---|---|---|
| `intake-requirement` | planner | Recording an email, chat, document or meeting as `SRC-###`, and raising CRs |
| `write-requirements` | planner | BRD and PRD with REQ-IDs and acceptance criteria |
| `write-design` | planner | Technical design, API contract, ADRs |
| `implement-feature` | developer | Test-first implementation of a REQ or BUG |
| `review-pr` | reviewer | Verification checklist and review report |
| `stack-*` | developer, reviewer | Project-specific commands and conventions. Edit these to match your stack |

Put project-specific notes in `CLAUDE.md`, not here. This file is overwritten when the framework is upgraded.
