---
name: write-requirements
description: Write or version the BRD (business requirements) and PRD (product requirements) from captured SRC sources and accepted change requests, with REQ-IDs, MoSCoW priority and Given/When/Then acceptance criteria. Use after intake, when requirements need to be created, clarified, or changed, and to record the human's approval of a BRD or PRD.
---
# Write requirements (BRD + PRD)

Templates in this folder: `BRD-template.md`, `PRD-template.md`. Versioning rules: `AGENTS.md` §4.

## 1. Gather inputs
- Sources in `requirements/register.md` with status `Analysed`
- CRs in `requirements/changes/` with status `Accepted`
- Answered questions in `tracking/questions.md` that affect requirements
- The current BRD and PRD versions, from `docs/index.md`

Anything not in these inputs is not a requirement. If you think something is missing, ask.

## 2. Decide which file to edit
| Current state | Action |
|---|---|
| No BRD/PRD yet | Create `docs/01-business/BRD-v1.0.md` and `docs/02-product/PRD-v1.0.md` from the templates, `status: Draft` |
| Latest is `Draft` or `In Review` | Edit it in place and add a revision-history row |
| Latest is `Approved` | Copy it to the next version (minor for additions and clarifications, major for removed or changed scope), set `Draft`, set `supersedes:`, and add a revision row citing the CR or SRC. Never touch the approved file. |

The BRD changes rarely. Update it only when business goals, stakeholders, scope boundaries or success metrics change.

## 3. Writing rules
- **One REQ is one testable behavior.** Split anything with "and" in its capability.
- Every REQ has: a story, a type (`Functional` or `Non-functional`), a MoSCoW priority, a business objective (`BO-#` from the BRD), its sources (`SRC-###`, or `CR-###`), a status, and at least one acceptance criterion.
- Acceptance criteria use **Given / When / Then**, are numbered `AC-<req>.<n>` (for example `AC-004.2`), and are verifiable by a test. Use concrete numbers: "within 2 s at 100 concurrent users", not "fast".
- Use the source's language for business rules. Do not add features, limits or rules that no source states. If one is needed, ask.
- Write no solution design in the PRD (no tables, endpoints or frameworks). That belongs in `write-design`.
- Unknowns are marked `TBD (Q-###)`, never guessed.
- **IDs are permanent.** A dropped REQ stays in the document with status `Rejected` or `Deferred` and the reason. Never renumber.
- When changing an existing REQ in a new version, keep its ID and record the change in the revision history and the REQ's "Change history" line.

## 4. Quality check before setting `In Review`
- [ ] Every REQ has a source, type, priority, objective, status, and at least one Given/When/Then criterion
- [ ] Every `TBD` has a Q-ID, and every blocking Q is listed in the PRD's open-questions section
- [ ] Every source used is marked `Incorporated (PRD-vX.Y)` in `requirements/register.md`
- [ ] No two REQs overlap or contradict each other
- [ ] Out-of-scope items are listed explicitly
- [ ] The traceability matrix has one row per REQ (new rows `Proposed`) with Sources and Spec filled in
- [ ] `docs/index.md` shows the new version and status

Then set `status: In Review` and log `doc_created` or `doc_versioned` plus `req_created` per new REQ.

## 5. Recording approval (Gate A)
Only when the human explicitly approves:
1. Set `status: Approved`, `approved_by`, `approved_on`. If this version supersedes an older one, set the older one to `Superseded`.
2. In traceability, set every in-scope REQ from `Proposed` to `Approved`.
3. Update `docs/index.md` and log `doc_approved` and `status_changed` events.
4. Mark the related CRs `Implemented`.
