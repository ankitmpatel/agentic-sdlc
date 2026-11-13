---
name: stack-bash
description: Commands and conventions for this repository (the agentic-sdlc installer) — a Bash 3.2-compatible setup script, Markdown/YAML/JSON templates, and a Bash test suite. Use when implementing or reviewing changes to agent-setup.sh, templates/ or tests/.
---
# Stack: Bash installer + Markdown templates

## Commands
| Purpose | Command | Verified |
|---|---|---|
| Full test suite | `bash tests/setup.test.sh` | ☑ 2026-11-12 |
| Syntax check | `bash -n agent-setup.sh && bash -n tests/setup.test.sh` | ☑ 2026-11-12 |
| Try an install | `cd "$(mktemp -d)" && bash <repo>/agent-setup.sh --type new` | ☑ 2026-11-12 |
| Lint (optional) | `shellcheck agent-setup.sh tests/setup.test.sh` | ☐ shellcheck not installed |

## Layout
```
agent-setup.sh                 # installer, copies templates/ into the target project
templates/AGENTS.core.md       # + AGENTS.brownfield.md → target AGENTS.md
templates/framework/claude/    # → target .claude/ (always upgraded, with backup)
templates/brownfield/          # extra framework + project files for existing projects
templates/project/             # → target root (created only when missing)
tests/setup.test.sh            # scenario tests in temp folders
```

## Conventions
- **Bash 3.2 compatible** (macOS default): no associative arrays, no `${var,,}`, no `mapfile`.
- Template folders are named `claude/`, never `.claude/`, so Claude Code doesn't load them as this repo's own config. `target_path()` maps them.
- Framework files are `managed` (upgraded, with a backup of local changes). Anything holding user data or customization is `missing` (never overwritten).
- Every new template file needs a test asserting that it is installed, and that it is preserved on re-run if it holds project data.
- Test names in `tests/setup.test.sh` describe the behavior. Group them by scenario, and reference REQ-IDs in the commit messages.
