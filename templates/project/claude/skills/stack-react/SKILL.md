---
name: stack-react
description: Commands and conventions for a React frontend — install, run, component tests, E2E tests with Playwright, data-testid naming, accessibility, API client usage. Use when implementing or reviewing frontend code in this project. Edit this file to match the project's real setup.
---
# Stack: React frontend

> **Customize this file.** It is installed once and never overwritten. Replace the defaults with the commands from this project's `package.json` and mark each one verified.

## Commands
| Purpose | Command | Verified |
|---|---|---|
| Install | `npm ci` | ☐ |
| Run (dev) | `npm run dev` | ☐ |
| Component tests | `npm test` (Vitest or Jest + React Testing Library) | ☐ |
| E2E tests | `npx playwright test` | ☐ |
| Single E2E file | `npx playwright test tests/e2e/REQ-004.spec.ts` | ☐ |
| Lint | `npm run lint` | ☐ |
| Type-check | `npx tsc --noEmit` | ☐ |
| Build | `npm run build` | ☐ |

## Layout
```
src/frontend/
  features/<feature>/   # components, hooks, api calls for one feature
  components/           # shared presentational components
  api/                  # typed client generated from or matching the API contract
tests/e2e/
  REQ-004.spec.ts       # one file per REQ
```

## Conventions
- **`data-testid` on every interactive element**, named `<feature>-<element>[-<action>]`, for example `reset-email-input` and `reset-submit-button`. Never reuse an ID on the same page.
- **E2E tests** select by `data-testid` (or by role for accessibility assertions), never by CSS class or text that may change. One spec file per REQ, with a `test()` per AC.
- **Component tests** use React Testing Library queries by role and label first.
- **Accessibility:** every input has a label, buttons have accessible names, the UI works by keyboard, and focus is visible. Run `@axe-core/playwright` if the project has it.
- **States:** every data view handles loading, empty and error states, as the PRD's UX notes specify.
- **API calls** go through `src/frontend/api/`, and their types match the approved contract. Don't call `fetch` directly from components.
- Keep components small. One component maps to a clear piece of a REQ.
