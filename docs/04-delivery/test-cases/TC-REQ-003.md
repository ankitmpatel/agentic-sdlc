---
doc_id: TC-REQ-003
title: Test cases — REQ-003 Multi-channel requirement intake
req: REQ-003
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-003 Multi-channel requirement intake

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-003.1 | AC-003.1 | Positive | Register, inbox, sources/attachments and changes created | New install | Check paths | All exist | Auto | `tests/setup.test.sh › "TC-003.1 requirement register, inbox, sources and changes created"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-003.4 | AC-003.2 | Positive | Intake skill defines SRC record fields and redaction | — | Read `intake-requirement/SKILL.md` §2 and `source-template.md` | Channel, from, original received date, reference, verbatim content, attachments and the redaction rule are all defined | Manual |  | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-003.5 | AC-003.3 | Positive | Changes to approved docs produce a CR needing a human decision | — | Read `intake-requirement/SKILL.md` §4 and `change-request-template.md` | A CR is created with status Proposed, and only an Accepted CR may lead to a new version | Manual |  | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-003.2 | AC-003.4 | Positive | Rules require committing raw sources | New install | grep the intake skill and AGENTS.md | Both rules present | Auto | `tests/setup.test.sh › "TC-003.2 intake skill requires committing raw sources"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| TC-003.3 | AC-003.4 | Negative | No installed `.gitignore` excludes requirement sources | New install | grep `.gitignore` | No `requirements` entry | Auto | `tests/setup.test.sh › "TC-003.3 no .gitignore excludes requirement sources"` | Pass (RUN-20261113-0251-REQ-001-branch) |
| — | AC-003.1–003.3 | Negative | N/A — no user input; loss of existing data on re-run is covered by TC-007.4 |  |  |  |  |  | — |
