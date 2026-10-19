# agentic-sdlc

A lightweight agent-based SDLC scaffold for new and existing projects. It creates global guardrails, project tracking, role-based agents, and optional reusable skills so the workflow can be adapted to different stacks.

## What this generates

When you run the setup script in a target project directory, it creates:

- `AGENTS.md` with cross-agent guardrails
- `.claude/agents/` with role-based instructions for:
  - PM
  - Architect
  - Backend Developer
  - UI Developer
  - QA Engineer
  - Reviewer
  - Onboarding Analyst (existing projects only)
- `.claude/skills/` with reusable workflow templates such as:
  - `create-brd`
  - `create-prd`
  - `create-design-doc`
  - `implement-backend`
  - `implement-frontend`
  - `run-qa-checks`
  - stack-specific examples such as `backend-node-express` and `frontend-react`
- Standard project documentation folders:
  - `docs/01-business`
  - `docs/02-product`
  - `docs/03-architecture`
  - `docs/04-delivery`
  - `docs/00-onboarding` for brownfield onboarding
- Tracking artifacts:
  - `CHANGELOG.md`
  - `tracking/activity.jsonl`
  - `tracking/progress/`

## Setup

Prerequisites:

- Bash
- Claude Code or another agent runner
- GitHub CLI (`gh`) for PR workflows

Run the script from the root of the project you want to initialize:

```bash
bash /path/to/agentic-sdlc/agent-setup.sh
```

The script will ask whether the target is:

- New project: creates `src/` and `tests/` scaffolding
- Existing project: preserves current source files and creates onboarding documentation folders

## Why skills are included

Skills are optional reusable execution patterns. They are not required for the framework to function, but they are useful when you want:

- role-specific workflow guidance
- stack swapping without rewriting each agent
- more detailed instructions for common tasks

Example:

- PM uses `create-brd` and `create-prd`
- Architect uses `create-design-doc`
- Backend dev uses `implement-backend` plus a stack override such as `backend-node-express`
- UI dev uses `implement-frontend` plus a stack override such as `frontend-react`
- QA uses `run-qa-checks`

This lets you keep the core agent responsibilities stable while swapping technology-specific execution instructions as needed.

## Start the workflow

From the target project root, launch Claude Code:

```bash
claude
```

Then instruct Claude to read the generated files and act as the desired role.

### New project flow

Use the PM agent first to generate requirements and product deliverables.

```text
Read AGENTS.md and .claude/agents/pm.md. Act as the PM and generate the initial requirements for [YOUR IDEA].
```

### Existing project flow

Start with onboarding to map the codebase before introducing new requirements.

```text
Read AGENTS.md and .claude/agents/onboarding.md. Act as the Onboarding Analyst and map this codebase without changing code.
```

## Agent responsibilities and flow

### PM

Purpose: define the business and product direction.

Skills:

- `create-brd`
- `create-prd`

How it works:

1. Create a feature branch
2. Create/update the progress file
3. Generate BRD and PRD docs
4. Assign REQ-IDs to each user story
5. Commit and open a PR

Example prompt:

> "Act as the PM. Read AGENTS.md and the repo docs. Create a BRD and PRD for [FEATURE NAME], assign REQ-IDs, and open a PR."

### Architect

Purpose: translate requirements into architecture and contracts.

Skills:

- `create-design-doc`

How it works:

1. Read the approved PRD
2. Create/update the architecture doc and API contract
3. Map endpoints and data contracts to REQ-IDs
4. Commit and open a PR

Example prompt:

> "Act as the Architect. Read AGENTS.md and the PRD. Update docs/03-architecture/tech_arch.md and api_contract.yaml, map each contract to a REQ-ID, and open a PR."

### Backend Developer

Purpose: implement backend behavior against the contract.

Skills:

- `implement-backend`
- optional stack override: `backend-node-express`

How it works:

1. Read the API contract and requirement docs
2. Implement the feature with minimal scope
3. Add unit tests
4. Run the relevant validation checks
5. Commit with the REQ-ID and open a PR

Example prompt:

> "Act as the Backend Developer. Read AGENTS.md and api_contract.yaml. Implement the backend for [REQ-ID], add tests, and open a PR."

### UI Developer

Purpose: implement frontend features with testable UI elements.

Skills:

- `implement-frontend`
- optional stack override: `frontend-react`

How it works:

1. Read the contract and requirement docs
2. Implement the UI
3. Add `data-testid` attributes to interactive elements
4. Verify the UI using the smallest relevant checks
5. Commit and open a PR

Example prompt:

> "Act as the UI Developer. Read AGENTS.md and api_contract.yaml. Implement the frontend for [REQ-ID], add `data-testid` attributes, and open a PR."

### QA Engineer

Purpose: validate behavior and maintain traceability.

Skills:

- `run-qa-checks`

How it works:

1. Read the requirement and implementation
2. Run targeted tests or UI checks
3. Update traceability docs
4. Report gaps or blockers clearly
5. Commit and open a PR

Example prompt:

> "Act as the QA Engineer. Read AGENTS.md and the requirements for [REQ-ID]. Write E2E tests, update docs/04-delivery/traceability.md, and open a PR."

### Reviewer

Purpose: validate PR quality without merging.

How it works:

1. Review the diff
2. Check REQ-ID usage, tests, and tracking updates
3. Leave a review with blocking comments if needed
4. Never merge the PR

Example prompt:

> "Act as the Reviewer. Review PR [PR NUMBER] using AGENTS.md. Validate REQ-ID traceability, test coverage, and tracking updates, then leave a review. Do not merge."

### Onboarding Analyst

Purpose: map an existing codebase to the SDLC framework without changing code.

How it works:

1. Scan the repository
2. Document architecture and business logic
3. Generate onboarding docs and REQ-IDs for current features
4. Open a documentation PR

Example prompt:

> "Act as the Onboarding Analyst. Read AGENTS.md and map this codebase without changing code. Generate docs/00-onboarding/architecture-map.md, As-Built-BRD.md, and As-Built-PRD.md with REQ-IDs."

## Stack swapping

The agent roles stay the same across projects, but the execution details can change by stack.

For example:

- Node/Express backend: use `backend-node-express`
- React frontend: use `frontend-react`
- Python/FastAPI backend: create a new `backend-python-fastapi.md` file and point the backend agent to it
- Next.js frontend: create a new `frontend-nextjs.md` file and point the UI agent to it

This keeps the SDLC process portable without rewriting the entire role model.

## Guardrails built into the workflow

The generated `AGENTS.md` includes the main guardrails:

- use repository files instead of chat memory as the source of truth
- never merge to `main`
- never overwrite approved specs without creating a new version
- include REQ-IDs in work products and commit references
- update tracking files for in-progress work
- validate with the smallest relevant tests or checks
- keep brownfield changes surgical and isolated

## Example project structure

```text
.
├── AGENTS.md
├── CHANGELOG.md
├── .claude/
│   ├── agents/
│   └── skills/
├── docs/
│   ├── 00-onboarding/
│   ├── 01-business/
│   ├── 02-product/
│   ├── 03-architecture/
│   └── 04-delivery/
├── tracking/
│   ├── activity.jsonl
│   ├── backlog/
│   ├── progress/
│   └── tech-debt/
├── src/
├── tests/
└── ...
```

## Notes

- The onboarding agent is only generated for existing projects.
- The PM, architecture, backend, frontend, QA, and reviewer roles are generated for both project types.
- Skills are optional, but they make the process more explicit and easier to swap by technology stack.

## License

This repository is provided as a general-purpose setup template for agent-driven SDLC workflows.