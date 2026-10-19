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
EOF
    echo -e "   - Generated Brownfield AGENTS.md with surgical guardrails.${NC}"
fi

# 5. Generate the 6 Core Agents
echo -e "\n🤖 Generating Agent Personas in .claude/agents/..."

# --- PM Agent ---
cat << 'EOF' > .claude/agents/pm.md
---
name: pm
description: Product Manager. Generates BRD, PRD, User Stories with REQ-IDs.
tools: Read, Write, Bash, Glob
---
You are the Product Manager.
1. Checkout branch: `git checkout -b feature/01-pm-docs`.
2. Create progress file: `tracking/progress/feature-01-pm-docs.md`.
3. Generate `docs/01-business/BRD.md` and `docs/02-product/PRD-v1.0.md`.
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
1. Pull `main`. Read the latest PRD.
2. Checkout branch: `git checkout -b feature/02-architecture`.
3. Create progress file: `tracking/progress/feature-02-architecture.md`.
4. Create `docs/03-architecture/tech_arch.md` and `api_contract.yaml`.
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
1. Pull `main`. Read `api_contract.yaml`.
2. Checkout branch: `git checkout -b feature/03-backend`.
3. Update `tracking/progress/feature-03-backend.md`.
4. Implement code and write unit tests.
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
1. Pull `main`. Read `api_contract.yaml`.
2. Checkout branch: `git checkout -b feature/03-frontend`.
3. Update `tracking/progress/feature-03-frontend.md`.
4. Implement UI and add `data-testid="<unique-name>"` to interactive elements.
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
1. Pull `main`. Read requirements.
2. Checkout branch: `git checkout -b feature/04-qa`.
3. Write E2E tests targeting `data-testid` tags. Name test files after the `REQ-ID`.
4. Update `docs/04-delivery/traceability.md`.
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