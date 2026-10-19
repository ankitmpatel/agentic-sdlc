# agentic-sdlc

## Setup

Run the setup script from the root of the project you want to initialize. It creates the Agentic SDLC files in the current directory.

Prerequisites:

- Bash
- Claude Code for running the generated agents
- GitHub CLI (`gh`) for the agents' pull request workflow

If this repository is available locally, run the script by its path while your terminal is in the target project's root:

```bash
bash /path/to/agentic-sdlc/agent-setup.sh
```

The script asks whether the target is a new or existing project:

- **1. New project:** creates `src/` and `tests/` scaffolding.
- **2. Existing project:** preserves existing source files and creates `docs/00-onboarding/` for codebase mapping.

Both options create `AGENTS.md`, agent definitions in `.claude/agents/`, documentation and tracking directories, `CHANGELOG.md`, and the activity ledger at `tracking/activity.jsonl`. Review the generated `AGENTS.md` before using the agents.

## Start the Workflow

From the target project root, start Claude Code:

```bash
claude
```

For a new project, ask Claude Code to read `AGENTS.md` and `.claude/agents/pm.md` and generate requirements for your idea. For an existing project, start with `.claude/agents/onboarding.md` to map the current codebase; after onboarding is merged, use the PM agent to plan new features.

## Agent Prompt Examples

Run these prompts from Claude Code in the target project. The onboarding agent is generated only for existing projects. Replace bracketed values with your project details.

### PM

> "Act as the PM. We need to add a new feature: [Feature Name]. Read `AGENTS.md` and `docs/00-onboarding/As-Built-PRD.md` to understand the current system. Generate a `CR-001` change request in `CHANGELOG.md` and a `PRD-v2.0.md` detailing the new requirement with a unique REQ-ID. Open a PR."

### Architect

> "Act as the Architect. Read `AGENTS.md`, the approved PRD, and the change request for [Feature Name]. Update `docs/03-architecture/tech_arch.md` and `docs/03-architecture/api_contract.yaml` to map the requirement to its data model and API contract. Open a PR."

### Backend Developer

> "Act as the Backend Developer. Read `AGENTS.md` and `docs/03-architecture/api_contract.yaml`. Implement the backend for [REQ-ID], add unit tests, and open a PR that references the REQ-ID."

### UI Developer

> "Act as the UI Developer. Read `AGENTS.md` and `docs/03-architecture/api_contract.yaml`. Implement the frontend for [REQ-ID], add `data-testid` attributes to interactive elements, and open a PR that references the REQ-ID."

### QA Engineer

> "Act as the QA Engineer. Read `AGENTS.md`, the requirements for [REQ-ID], and the implemented feature. Write E2E tests using its `data-testid` attributes, update `docs/04-delivery/traceability.md` to link the requirement, code, and tests, and open a PR."

### Reviewer

> "Act as the Reviewer. Review PR [PR Number] using `AGENTS.md`. Check the REQ-ID, tests, and tracking updates, then leave a review with any findings. Do not merge the PR."

### Onboarding (Existing Projects)

> "Act as the Onboarding Analyst. Read `AGENTS.md` and map this codebase without changing code. Generate `docs/00-onboarding/architecture-map.md`, `docs/00-onboarding/As-Built-BRD.md`, and `docs/00-onboarding/As-Built-PRD.md`, assigning REQ-IDs to existing features. Open a documentation PR."