---
name: write-design
description: Write or version the technical design, OpenAPI contract and architecture decision records (ADRs) for approved PRD requirements, mapping every component and endpoint to REQ-IDs. Use after the PRD is approved (Gate A), when the design or contract must change, and to record the human's approval of a design (Gate B).
---
# Write the technical design

Templates in this folder: `tech-design-template.md`, `api-contract-template.yaml`, `adr-template.md`. Versioning rules: `AGENTS.md` §4.

## 1. Preconditions
- The PRD version you are designing for has `status: Approved`. If it doesn't, **stop**: Gate A is missing.
- Read the PRD, the existing design and contract (from `docs/index.md`), `CLAUDE.md`, the stack skill, and for existing projects the onboarding architecture map.

## 2. Files
| File | Location |
|---|---|
| Technical design | `docs/03-architecture/tech-design-vX.Y.md` |
| API contract (OpenAPI 3.1) | `docs/03-architecture/api-contract-vX.Y.yaml`. `info.version` must match the file name. |
| ADRs | `docs/03-architecture/adr/ADR-###-<slug>.md`, one per significant decision |

The same rules apply as for the PRD: create v1.0, edit drafts in place, and copy approved files to a new version. A **breaking** contract change (a removed or renamed field or endpoint, or a changed type) is a major version.

## 3. Design rules
- **Coverage:** every in-scope REQ appears in the design's REQ coverage table. A REQ that needs no technical work says so and gives the reason.
- **Contract traceability:** every operation has `x-req-ids: [REQ-###]`, and every REQ that touches the API has at least one operation.
- **Errors:** one shared error schema, with documented status codes on every operation.
- **Security:** authentication and authorization per endpoint, input validation, handling of personal data, secrets management.
- **Non-functional REQs:** describe how each one is met and how it will be tested.
- **Testing strategy:** for each REQ, say which levels (unit, integration, E2E) cover which acceptance criteria. The developer follows this.
- **Existing projects:** reuse the existing patterns. Any new pattern or dependency needs an ADR.
- **Ask** (`AGENTS.md` §6) before choosing anything with cost, vendor, data-retention, security or UX impact. Present options with trade-offs in the question. Don't decide silently.

## 4. Quality check before setting `In Review`
- [ ] Every in-scope REQ is in the coverage table
- [ ] Every operation has `x-req-ids`, request and response schemas, and error responses
- [ ] The contract is valid YAML (`python3 -c "import yaml,sys; yaml.safe_load(open(sys.argv[1]))" <file>` or the project's OpenAPI linter)
- [ ] Each significant decision has an ADR with the alternatives considered
- [ ] The testing strategy maps every acceptance criterion to a test level
- [ ] The traceability Design column links the design and contract versions, and the REQs are `In Design`
- [ ] `docs/index.md` is updated, and `doc_created` or `doc_versioned` is logged

## 5. Recording approval (Gate B)
Only when the human explicitly approves: set the design and contract to `Approved` (and the accepted ADRs to `Accepted`), set the covered REQs to `Ready` in traceability, update `docs/index.md`, and log `doc_approved` and `status_changed`.
