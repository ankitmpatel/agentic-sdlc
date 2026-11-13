---
doc_id: TC-REQ-001
title: Test cases — REQ-001 Lean agent roster
req: REQ-001
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-001 Lean agent roster

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-001.1 | AC-001.1 | Positive | New install has exactly planner, developer, reviewer | Empty folder | `--type new`; list `.claude/agents/` | planner.md, developer.md, reviewer.md exist | Auto | `tests/setup.test.sh › "TC-001.1 planner, developer and reviewer agents installed"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-001.2 | AC-001.1, AC-001.2 | Negative | New install has no onboarding agent | Empty folder | `--type new` | `onboarding.md` absent | Auto | `tests/setup.test.sh › "TC-001.2 no onboarding agent in a new project"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-001.3 | AC-001.2 | Positive | Existing install adds onboarding | Folder with `src/app.js` | `--type existing` | `onboarding.md` exists | Auto | `tests/setup.test.sh › "TC-001.3 onboarding agent added"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-001.4 | AC-001.3 | Positive | Agent frontmatter name matches file and has description | Installed project (new and existing) | Read every agent frontmatter | `name` = file name; `description:` present | Auto | `tests/setup.test.sh › "TC-001.4 agent names match file names and have descriptions"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| — | AC-001.3 | Negative | N/A — the check runs over every installed agent, so any malformed agent fails TC-001.4 |  |  |  |  |  | — |
