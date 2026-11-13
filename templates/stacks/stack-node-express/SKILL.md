---
name: stack-node-express
description: Commands and conventions for a Node.js + Express backend — install, run, test, lint, type-check, folder layout, validation and error handling. Use when implementing or reviewing backend code in this project. Edit this file to match the project's real setup.
---
# Stack: Node.js + Express backend

> **Customize this file.** It is installed once and never overwritten. Replace the defaults with the commands from this project's `package.json` and mark each one verified.

## Commands
Check the `package.json` `scripts` first. The defaults below assume npm.

| Purpose | Command | Verified |
|---|---|---|
| Install | `npm ci` | ☐ |
| Run (dev) | `npm run dev` | ☐ |
| Unit + integration tests | `npm test` | ☐ |
| Single test file | `npx vitest run <file>` or `npx jest <file>` | ☐ |
| Lint | `npm run lint` | ☐ |
| Type-check | `npx tsc --noEmit` | ☐ |

## Layout
```
src/backend/
  routes/      # HTTP layer only: parse, validate, call service, map to response
  services/    # business logic, no req/res objects
  repositories/# data access
  middleware/  # auth, error handler, request logging
tests/backend/
  unit/        # services, pure functions
  integration/ # routes via supertest against the app instance
```

## Conventions
- **Validate every request** at the route against the contract's schema (zod, joi, or whatever the project already uses). Reject with `400` and the contract's `Error` shape.
- **One error handler** middleware maps thrown domain errors to contract status codes. Never leak stack traces.
- **Authorization** is enforced in middleware or the service layer, never only in the UI.
- **Config** comes from environment variables, with `.env.example` documenting each one. No secrets in the repo.
- **Integration tests** use `supertest(app)` and assert status, body shape and the error codes listed in the contract.
- **Test names** start with the REQ and AC: `describe('REQ-004 password reset')`, `it('AC-004.2 rejects expired token')`.
- Database tests use a disposable test database or transactions rolled back after each test.
