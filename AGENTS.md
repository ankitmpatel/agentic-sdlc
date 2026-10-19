# Global Agent Rules (Brownfield / Existing Project)

## 1. Brownfield Guardrails (CRITICAL)
- **Do Not Rewrite:** Do not refactor or rewrite existing files unless explicitly instructed.
- **Surgical Changes:** Make the smallest possible changes to implement new features.
- **Test Before Change:** Before modifying an existing file, ensure there are tests covering its current behavior.
- **Isolation:** Place all new features in new, separate files. Only modify existing files to register the new feature.

## 2. Artifacts > Chat Memory
Every agent must rely on files in the repository, not conversational context. Every output must be committed to a feature branch and opened as a Pull Request (PR). No agent may merge to `main`.

## 3. Traceability & Versioning
- **Versioned Specs:** Never overwrite an approved spec. Create a new version (e.g., `PRD-v1.1.md`).
- **Requirement IDs:** Assign a unique ID to every User Story (e.g., `REQ-001`).
- **Commit Linking:** All commits and PR titles MUST reference the `REQ-ID`.

## 4. Ongoing Development Tracking
- **Progress Files:** Every active branch must have a `tracking/progress/<branch-name>.md` file.
- **Activity Ledger:** Append JSON lines to `tracking/activity.jsonl` for task transitions.

## 5. Skills and Stack Swapping
- Skills are optional reusable execution patterns stored in `.claude/skills/`.
- If a project uses a different stack, swap the relevant backend/frontend skill files rather than rewriting the agent definitions.
- This keeps the workflow portable across Node, Python, React, Next.js, or other technology stacks.
