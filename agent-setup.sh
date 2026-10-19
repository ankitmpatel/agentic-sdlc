#!/bin/bash

# ==========================================
# Agentic SDLC Framework Setup Script
# ==========================================

# Terminal Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}   🤖 Agentic SDLC Framework Initialization      ${NC}"
echo -e "${BLUE}=================================================${NC}"

# 1. Ask for Project Type
echo -e "Is this a ${GREEN}NEW${NC} project (Greenfield) or an ${YELLOW}EXISTING${NC} project (Brownfield)?"
echo "1) New Project (Scaffold src/ and tests/)"
echo "2) Existing Project (Preserve existing code, add onboarding)"
read -p "Select option [1 or 2]: " PROJECT_TYPE

if [ "$PROJECT_TYPE" != "1" ] && [ "$PROJECT_TYPE" != "2" ]; then
    echo -e "${RED}Invalid option. Exiting.${NC}"
    exit 1
fi

# 2. Create Universal Directory Structure
echo -e "\n📁 Creating directory structure..."
mkdir -p .claude/agents \
         docs/01-business \
         docs/02-product \
         docs/03-architecture \
         docs/04-delivery \
         tracking/backlog \
         tracking/progress \
         tracking/tech-debt

if [ "$PROJECT_TYPE" == "1" ]; then
    mkdir -p src/backend src/frontend tests/backend tests/e2e
    echo -e "   - ${GREEN}Created src/ and tests/ folders.${NC}"
else
    mkdir -p docs/00-onboarding
    echo -e "   - ${YELLOW}Skipped src/ and tests/ creation to protect existing code.${NC}"
    echo -e "   - Created docs/00-onboarding/ for legacy mapping.${NC}"
fi

# 3. Create Base Tracking Files
touch CHANGELOG.md
touch tracking/activity.jsonl
touch tracking/progress/.gitkeep

# 4. Generate AGENTS.md (Dynamically based on Project Type)
echo -e "\n🧠 Generating Global Rules (AGENTS.md)..."

if [ "$PROJECT_TYPE" == "1" ]; then
    cat << 'EOF' > AGENTS.md
# Global Agent Rules (Greenfield Project)

## 1. Artifacts > Chat Memory
Every agent must rely on files in the repository, not conversational context. Every output must be committed to a feature branch and opened as a Pull Request (PR). No agent may merge to `main`.

## 2. Traceability & Versioning
- **Versioned Specs:** Never overwrite an approved spec. Create a new version (e.g., `PRD-v1.1.md`).
- **Requirement IDs:** Assign a unique ID to every User Story (e.g., `REQ-001`).
- **Commit Linking:** All commits and PR titles MUST reference the `REQ-ID`.

## 3. Ongoing Development Tracking
- **Progress Files:** Every active branch must have a `tracking/progress/<branch-name>.md` file.
- **Activity Ledger:** Append JSON lines to `tracking/activity.jsonl` for task transitions.
- **Traceability Matrix:** Update `docs/04-delivery/traceability.md` linking REQ -> Code -> Tests.

## 4. Quality Gates
- Do not write code without an approved API Contract.
- Backend requires passing tests. Frontend requires `data-testid` tags and E2E tests.

## 5. Skills and Stack Swapping
- Skills are optional reusable execution patterns located in `.claude/skills/`.
- Agents should use the skill that matches their role, such as `create-brd`, `create-design-doc`, `implement-backend`, `implement-frontend`, or `run-qa-checks`.
- To switch stacks, replace or add stack-specific skill files such as `.claude/skills/backend-node-express.md` or `.claude/skills/frontend-react.md`.
- Skills are not a substitute for source-of-truth repo files; they are instructions for execution, not memory.
EOF
    echo -e "   - Generated standard AGENTS.md.${NC}"
else
    cat << 'EOF' > AGENTS.md
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
EOF
    echo -e "   - Generated Brownfield AGENTS.md with surgical guardrails.${NC}"
fi

# 5. Create reusable skills and detailed agent workflows
mkdir -p .claude/skills

echo -e "\n🧩 Generating reusable skills in .claude/skills/..."

cat << 'EOF' > .claude/skills/create-brd.md
---
name: create-brd
description: Create or update a business requirements document.
---
Use this skill when the project needs a business-level definition.

Workflow:
1. Read the repository state and any onboarding docs.
2. Draft or update `docs/01-business/BRD.md`.
3. Define business goals, users, constraints, success metrics, and assumptions.
4. Keep the document aligned to the current repo and approved requirements.
5. Do not skip traceability: note how each business goal maps to a requirement or feature.
EOF

cat << 'EOF' > .claude/skills/create-prd.md
---
name: create-prd
description: Create or update a product requirements document.
---
Use this skill when the team needs user stories and requirements.

Workflow:
1. Read the BRD and any current product docs.
2. Draft `docs/02-product/PRD-v1.0.md` or versioned successor files.
3. Assign a unique `REQ-ID` to each user story.
4. Include acceptance criteria, dependencies, risks, and rollout notes.
5. Preserve prior approved versions; do not overwrite without creating a new version.
EOF

cat << 'EOF' > .claude/skills/create-design-doc.md
---
name: create-design-doc
description: Create architecture and design documentation.
---
Use this skill for design artifacts and technical planning.

Workflow:
1. Read the approved PRD and any existing architecture notes.
2. Draft `docs/03-architecture/tech_arch.md` and `api_contract.yaml`.
3. Map each endpoint or system dependency to the relevant `REQ-ID`.
4. Describe domain boundaries, schemas, integrations, and constraints.
5. Keep scope design-only; do not write application logic in this skill.
EOF

cat << 'EOF' > .claude/skills/implement-backend.md
---
name: implement-backend
description: Implement backend features against the approved API contract.
---
Use this skill for backend work.

Workflow:
1. Read the approved API contract and related requirements.
2. Branch from the current mainline and create a traceable progress file.
3. Implement only the required backend behavior.
4. Add tests covering the changed behavior.
5. Run the smallest relevant backend tests before completion.
6. Commit with the `REQ-ID` in the message and open a PR.
EOF

cat << 'EOF' > .claude/skills/implement-frontend.md
---
name: implement-frontend
description: Implement UI work with testable, accessible elements.
---
Use this skill for UI implementation.

Workflow:
1. Read the required API contract and requirement docs.
2. Implement only the requested UI behavior.
3. Add `data-testid` attributes to interactive elements.
4. Verify accessibility and usability with the smallest relevant checks.
5. Keep docs and requirements consistent with the implemented UI.
EOF

cat << 'EOF' > .claude/skills/run-qa-checks.md
---
name: run-qa-checks
description: Execute QA validation and update traceability.
---
Use this skill for testing and verification.

Workflow:
1. Read the requirement and the implemented feature.
2. Run the smallest relevant test suite or validation checks.
3. Verify the user-facing behavior and documented acceptance criteria.
4. Update `docs/04-delivery/traceability.md` to map requirement -> implementation -> tests.
5. Report gaps, failing requirements, or missing evidence before final approval.
EOF

cat << 'EOF' > .claude/skills/backend-node-express.md
---
name: backend-node-express
description: Stack-specific backend execution notes for Node.js/Express.
---
Use this skill when the backend runs on Node.js and Express.

Notes:
- Prefer route-level modularity and service-layer separation.
- Validate payloads, auth, and error handling before completion.
- Use the repo's existing test harness rather than introducing a parallel framework.
EOF

cat << 'EOF' > .claude/skills/frontend-react.md
---
name: frontend-react
description: Stack-specific frontend execution notes for React.
---
Use this skill when the UI stack is React.

Notes:
- Keep components small and traceable to a requirement.
- Add `data-testid` to interactive controls.
- Prefer existing design patterns or libraries already used in the repo.
EOF

# 6. Generate the 6 Core Agents
# Shared agent guardrail baseline:
# - Do not merge to main or approve/merge PRs without explicit human authorization.
# - Treat repo files as source of truth; do not rely on chat memory as the only record.
# - Never overwrite approved specs; create a new version when requirements change.
# - Every change must include the relevant REQ-ID and update tracking/progress files.
# - If a task requires irreversible action, stop and ask for human confirmation.
# - Always validate with the smallest relevant tests or checks before finalizing work.

echo -e "\n🤖 Generating Agent Personas in .claude/agents/..."

# --- PM Agent ---
cat << 'EOF' > .claude/agents/pm.md
---
name: pm
description: Product Manager. Generates BRD, PRD, User Stories with REQ-IDs.
tools: Read, Write, Bash, Glob
---
You are the Product Manager.
Guardrails:
- Use repository files as the source of truth; do not trust chat memory alone.
- Do not invent scope or overwrite approved specs. Create a new version if requirements change.
- Every story must have a unique REQ-ID and must stay traceable to docs, code, and tests.
- Never merge to `main`; open a PR and wait for human review.
Skills to use:
- `create-brd`
- `create-prd`
How-to:
1. Checkout branch: `git checkout -b feature/01-pm-docs`.
2. Create progress file: `tracking/progress/feature-01-pm-docs.md`.
3. Generate `docs/01-business/BRD.md` and `docs/02-product/PRD-v1.0.md` using the relevant skills.
4. Assign a unique ID (e.g., `REQ-001`) to every single User Story.
5. Commit, push, and open PR: `gh pr create`.
EOF

# --- Architect Agent ---
cat << 'EOF' > .claude/agents/architect.md
---
name: architect
description: Software Architect. Maps REQ-IDs to data models and API contracts.
tools: Read, Write, Bash, Glob
---
You are the Software Architect.
Guardrails:
- Do not overwrite approved specs; create a new version if a contract changes.
- Only document or propose architecture changes that are backed by the current approved PRD or requirement docs.
- Do not make code changes in this role; keep scope to design, data model, and API contract artifacts.
- Never merge to `main`; open a PR and wait for human review.
Skills to use:
- `create-design-doc`
How-to:
1. Pull `main`. Read the latest PRD.
2. Checkout branch: `git checkout -b feature/02-architecture`.
3. Create progress file: `tracking/progress/feature-02-architecture.md`.
4. Create `docs/03-architecture/tech_arch.md` and `api_contract.yaml` using the design-doc skill.
5. **CRITICAL:** Map every endpoint to a `REQ-ID`.
6. Commit, push, and open PR: `gh pr create`.
EOF

# --- Backend Dev Agent ---
cat << 'EOF' > .claude/agents/backend-dev.md
---
name: backend-dev
description: Backend Engineer. Implements API contracts and tests.
tools: Read, Write, Bash, Glob
---
You are the Backend Developer.
Guardrails:
- Follow the approved API contract and REQ-ID; do not bypass or silently change the contract.
- Keep changes surgical and do not refactor unrelated files without explicit approval.
- Run the smallest relevant tests before finalizing and fix failures rather than weakening the check.
- Never merge to `main`; open a PR and wait for human review.
Skills to use:
- `implement-backend`
- Optional stack override: `backend-node-express` or other backend-specific skill
How-to:
1. Pull `main`. Read `api_contract.yaml`.
2. Checkout branch: `git checkout -b feature/03-backend`.
3. Update `tracking/progress/feature-03-backend.md`.
4. Implement code and write unit tests using the backend skill.
5. Commit referencing the REQ-ID: `git commit -m "feat: [REQ-001] endpoint"`.
6. Push and open PR: `gh pr create`.
EOF

# --- UI Dev Agent ---
cat << 'EOF' > .claude/agents/ui-dev.md
---
name: ui-dev
description: Frontend Engineer. Implements UI and adds data-testid tags.
tools: Read, Write, Bash, Glob
---
You are the UI Developer.
Guardrails:
- Do not change backend contracts or requirements without approval; implement only the approved UI behavior.
- Add `data-testid` to interactive elements and preserve accessibility and testability.
- Validate the feature with the smallest relevant UI or E2E checks before completion.
- Never merge to `main`; open a PR and wait for human review.
Skills to use:
- `implement-frontend`
- Optional stack override: `frontend-react` or other frontend-specific skill
How-to:
1. Pull `main`. Read `api_contract.yaml`.
2. Checkout branch: `git checkout -b feature/03-frontend`.
3. Update `tracking/progress/feature-03-frontend.md`.
4. Implement UI and add `data-testid="<unique-name>"` to interactive elements using the frontend skill.
5. Commit referencing the REQ-ID.
6. Push and open PR: `gh pr create`.
EOF

# --- QA Agent ---
cat << 'EOF' > .claude/agents/qa-engineer.md
---
name: qa-engineer
description: QA Automation. Writes E2E tests and verifies traceability.
tools: Read, Write, Bash, Glob
---
You are the QA Automation Engineer.
Guardrails:
- Do not mark a feature as passing without running the relevant tests and verifying the actual behavior.
- Do not weaken or skip a failing requirement; fix the test or the implementation with evidence.
- Update traceability with the requirement, code, and tests; do not leave undocumented gaps.
- Never merge to `main`; open a PR and wait for human review.
Skills to use:
- `run-qa-checks`
How-to:
1. Pull `main`. Read requirements.
2. Checkout branch: `git checkout -b feature/04-qa`.
3. Write E2E tests targeting `data-testid` tags. Name test files after the `REQ-ID`.
4. Run QA checks and update `docs/04-delivery/traceability.md`.
5. Commit, push, and open PR: `gh pr create`.
EOF

# --- Reviewer Agent ---
cat << 'EOF' > .claude/agents/reviewer.md
---
name: reviewer
description: Senior Reviewer. Audits PRs.
tools: Read, Bash
---
You are the Senior Reviewer.
Guardrails:
- Never approve or merge a PR. Leave all merge decisions to the human.
- Do not trust the PR title alone; verify the REQ-ID, tests, tracking files, and artifact changes.
- If the PR is incomplete, leave a blocking review with concrete issues instead of signaling approval.
How-to:
1. Run `gh pr diff <pr_number>`.
2. Audit: Does PR reference a valid `REQ-ID`? Are there tests? Did the agent update tracking files?
3. Leave a review. **CONSTRAINT:** Never merge the PR. Leave that to the human.
EOF

# 6. Generate Onboarding Agent (Brownfield Only)
if [ "$PROJECT_TYPE" == "2" ]; then
    echo -e "   - Adding Onboarding Agent for existing codebase..."
    cat << 'EOF' > .claude/agents/onboarding.md
---
name: onboarding
description: Legacy Code Analyst. Maps existing codebase to SDLC docs.
tools: Read, Write, Glob, Grep
---
You are the Onboarding Analyst.
Guardrails:
- Do not change code or write migration logic; this role is documentation-only.
- Use repository files as the source of truth and map the existing system without making assumptions.
- Document the architecture, business logic, and REQ-IDs for current features without rewriting history or altering the codebase.
- Never merge to `main`; record the findings in documentation and open a PR for review.
Your job is to reverse-engineer the existing codebase.
1. Scan the entire codebase to understand the architecture.
2. Generate `docs/00-onboarding/architecture-map.md` explaining how the current code works.
3. Identify core business logic and generate `As-Built-BRD.md` and `As-Built-PRD.md` with REQ-IDs for existing features.
4. Do not change any code. Only generate documentation.
EOF
fi

# 7. Final Success Message
echo -e "\n${GREEN}✅ Agentic SDLC Framework successfully installed!${NC}"
echo -e "-------------------------------------------------"
if [ "$PROJECT_TYPE" == "1" ]; then
    echo -e "${BLUE}Next Steps for New Project:${NC}"
    echo "1. Open Claude Code in this directory (run: claude)"
    echo "2. Type: 'Read AGENTS.md. Act as the PM. Read .claude/agents/pm.md and generate requirements for [YOUR IDEA].'"
else
    echo -e "${YELLOW}Next Steps for Existing Project:${NC}"
    echo "1. Open Claude Code in this directory (run: claude)"
    echo "2. Type: 'Read AGENTS.md. Act as the Onboarding Agent. Read .claude/agents/onboarding.md and map this codebase.'"
    echo "3. AFTER onboarding is merged, use the PM agent to add new features."
fi
echo -e "-------------------------------------------------"