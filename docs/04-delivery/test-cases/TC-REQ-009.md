---
doc_id: TC-REQ-009
title: Test cases — REQ-009 All setup through the installer
req: REQ-009
based_on: PRD-v1.1
created: 2026-11-13
updated: 2026-11-13
---

# Test cases — REQ-009 All setup through the installer

## Revision history
| Date | Author | Change | Reason |
|---|---|---|---|
| 2026-11-13 | main session (Claude) | Initial test cases, written before implementation | PRD-v1.1, SRC-007 |

## Test cases
| TC | AC | Type | Title | Preconditions / data | Steps | Expected result | Mode | Automated test | Last result |
|---|---|---|---|---|---|---|---|---|---|
| TC-009.1 | AC-009.1 | Positive | `--stack node-express` installs only that stack skill | Empty folder | `--type new --stack node-express` | `stack-node-express/` present; `stack-react/` and `stack-project/` absent | Auto | `tests/setup.test.sh › "TC-009.1 --stack node-express installs only stack-node-express"` | Not run |
| TC-009.2 | AC-009.1 | Positive | `--stack both` installs Node/Express and React | Empty folder | `--type new --stack both` | Both present; `stack-project/` absent | Auto | `tests/setup.test.sh › "TC-009.2 --stack both installs stack-node-express and stack-react"` | Not run |
| TC-009.3 | AC-009.1 | Positive | `--stack other` installs a valid blank template | Empty folder | `--type new --stack other` | Only `stack-project/SKILL.md`, with `name: stack-project` | Auto | `tests/setup.test.sh › "TC-009.3 --stack other installs only a valid stack-project template"` | Not run |
| TC-009.4 | AC-009.1 | Positive | Without a terminal or `--stack`, the blank template is installed | Empty folder, stdin not a terminal | `--type new` | Only `stack-project/` installed | Auto | `tests/setup.test.sh › "TC-009.4 no terminal and no --stack installs only stack-project"` | Not run |
| TC-009.5 | AC-009.1 | Positive | Interactive menu installs the chosen stack | Empty folder, real terminal | Run `agent-setup.sh` and answer `1` (new), then `2` (React) | Only `stack-react/` installed | Manual | | Not run |
| TC-009.6 | AC-009.2 | Negative | Invalid `--stack` rejected before installing | Empty folder | `--type new --stack cobol` | Non-zero exit; error names the valid values; no `AGENTS.md` created | Auto | `tests/setup.test.sh › "TC-009.6 invalid --stack rejected and nothing installed"` | Not run |
| TC-009.7 | AC-009.2 | Negative | Re-run with an existing stack skill adds none | Project with `stack-react/` only | Re-run `--type new`, no `--stack` | No `stack-project/` or `stack-node-express/` added | Auto | `tests/setup.test.sh › "TC-009.7 re-run with an existing stack skill adds no stack skill"` | Not run |
| TC-009.8 | AC-009.3 | Positive | `--remove-legacy` removes previous-version files | `pm.md`, `create-prd.md` present | `--type new --remove-legacy` | Both removed; output says they were removed | Auto | `tests/setup.test.sh › "TC-009.8 --remove-legacy removes previous-version files"` | Not run |
| TC-009.9 | AC-009.3 | Negative | `--remove-legacy` removes nothing else | Custom `.claude/agents/my-agent.md` and `.claude/skills/my-skill/SKILL.md` present | `--type new --remove-legacy` | Both custom files remain | Auto | `tests/setup.test.sh › "TC-009.9 --remove-legacy keeps files that are not legacy"` | Not run |
| TC-009.10 | AC-009.4 | Positive | New project scaffold has placeholder files | Empty folder | `--type new` | `.gitkeep` in src/backend, src/frontend, tests/backend, tests/e2e | Auto | `tests/setup.test.sh › "TC-009.10 new project scaffold has .gitkeep placeholders"` | Not run |
| TC-007.3 | AC-009.4 | Negative | Existing project gets no scaffold (shared with REQ-007) | — | See TC-REQ-007 | — | Auto | `tests/setup.test.sh › "TC-007.3 existing source untouched and no src/backend scaffold"` | Not run |
| TC-009.12 | AC-009.5 | Positive | Install record and ledger event written | Empty folder | `--type new --stack react` | `.claude/sdlc.json` is valid JSON with framework_version, project_type "new", stacks ["stack-react"], installed_at; ledger has `framework_installed` | Auto | `tests/setup.test.sh › "TC-009.12 sdlc.json records version, type and stacks; ledger has framework_installed"` | Not run |
| TC-009.14 | AC-009.5 | Positive | Re-run without `--type` uses the recorded type | Existing-project install with sdlc.json | Re-run with no options, no terminal | Exit 0; onboarding still installed; ledger has `framework_upgraded`; installed_at unchanged | Auto | `tests/setup.test.sh › "TC-009.14 re-run without --type uses the recorded type and logs framework_upgraded"` | Not run |
| TC-009.15 | AC-009.5 | Negative | No terminal, no `--type` and no record → clear error | Empty folder, stdin not a terminal | Run with no options | Non-zero exit; message mentions `--type`; no `AGENTS.md` created | Auto | `tests/setup.test.sh › "TC-009.15 no terminal, no --type and no record exits non-zero"` | Not run |
| TC-009.13 | AC-009.6 | Negative | Installer leaves git untouched | Git repo with one commit on `main`, clean | `--type existing --stack other` | Same HEAD commit and branch; nothing staged; installed files are only untracked | Auto | `tests/setup.test.sh › "TC-009.13 installer leaves git untouched (HEAD, branch, index)"` | Not run |
| TC-009.16 | AC-009.6 | Positive | Reminders printed | Empty folder | `--type new` | Output tells you to commit the installed files and to protect `main` | Auto | `tests/setup.test.sh › "TC-009.16 output reminds to commit and protect main"` | Not run |
| — | AC-009.6 | Negative | N/A beyond TC-009.13: GitHub settings can't be changed without `gh` and network access, and the script has no `gh` calls (TC-009.13 also greps for them) | | | | | | — |

## Manual case details
**TC-009.5:** the menu needs a real terminal. In a new empty folder, run `bash /path/to/agent-setup.sh`, type `1` at the project-type prompt and `2` at the stack prompt, then check that `.claude/skills/` contains only `stack-react/` alongside the core skills. Not automated because the suite runs without a terminal; non-interactive paths are covered by TC-009.1–TC-009.4.
