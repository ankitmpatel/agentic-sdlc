---
name: stack-project
description: Commands and conventions for this project's own stack — install, run, test, lint, type-check, build, folder layout and coding conventions. Use when implementing or reviewing code in this project. Fill in this template with the project's real commands before relying on it.
---
# Stack: <your stack, e.g. Python + FastAPI, PHP + Laravel, Next.js>

> **Fill this in.** It is installed once and never overwritten. Replace every `<...>` with this project's real commands, run each one, and tick it as verified. In an existing project the onboarding agent fills this in from the codebase.

## Commands
| Purpose | Command | Verified |
|---|---|---|
| Install dependencies | `<e.g. pip install -r requirements.txt / composer install / npm ci>` | ☐ |
| Run (dev) | `<command>` | ☐ |
| Unit + integration tests | `<command>` | ☐ |
| Single test file | `<command> <file>` | ☐ |
| E2E tests | `<command, or "none">` | ☐ |
| Lint | `<command>` | ☐ |
| Type-check | `<command, or "none">` | ☐ |
| Build | `<command, or "none">` | ☐ |

## Layout
```
<where the source, tests, config and migrations live>
```

## Conventions
- **Test names** start with the REQ and TC IDs: `REQ-004 TC-004.2 rejects expired token`.
- **Validation and errors:** <how requests are validated and how errors map to the API contract's error schema>
- **Config and secrets:** <how configuration is loaded; never commit secrets>
- **UI:** <if there is one: `data-testid` naming, accessibility checks>
- **Data:** <test database setup and cleanup>
