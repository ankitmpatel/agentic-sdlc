---
doc_id: TC-REQ-002
title: Test cases — REQ-002 Valid, non-duplicated skills
req: REQ-002
based_on: PRD-v1.0
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-002 Valid, non-duplicated skills

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, mapped to tests/setup.test.sh | SRC-003, REQ-008 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-002.1 | AC-002.1 | Positive | Skills use `<name>/SKILL.md` with matching name and description ≥ 40 chars | New install | Inspect every `.claude/skills/*/` | All valid | Auto | `tests/setup.test.sh › "TC-002.1 skills use <name>/SKILL.md with matching name and description"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-002.4 | AC-002.1 | Negative | No `.claude` folder inside `templates/` (it would load as nested config in this repo) | Repo checkout | `find templates -name .claude` | No result | Auto | `tests/setup.test.sh › "TC-002.4 no folder named .claude inside templates/"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-002.2 | AC-002.2 | Positive | Every core skill an agent names is installed | New install | Collect skill names from agent files | Each has `SKILL.md` | Auto | `tests/setup.test.sh › "TC-002.2 every core skill named by an agent is installed"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-002.5 | AC-002.3 | Positive | All spec templates installed | New install | Check template files | BRD, PRD, source, CR, tech design, OpenAPI, ADR present | Auto | `tests/setup.test.sh › "TC-002.5 BRD, PRD, source, CR, tech-design, OpenAPI and ADR templates installed"` | Pass (RUN-20261113-0331-REQ-009-branch) |
| TC-002.3 | AC-002.3 | Negative | API contract template parses as YAML (catches broken syntax) | PyYAML installed | `yaml.safe_load` | No parse error | Auto | `tests/setup.test.sh › "TC-002.3 API contract template is valid YAML"` | Skipped (RUN-20261113-0331-REQ-009-branch, PyYAML missing) |
