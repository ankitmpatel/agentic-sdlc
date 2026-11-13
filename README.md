# agentic-sdlc

A lean, fully tracked software development process for Claude Code. Three agents and five skills take a feature from a raw email or chat message to a reviewed PR, with document versioning, traceability, and agents that ask instead of guessing.

## Setup

Prerequisites: Bash, Git, [Claude Code](https://claude.com/claude-code), and optionally the GitHub CLI (`gh`) for opening PRs.

```bash
git clone https://github.com/ankitmpatel/agentic-sdlc.git
cd /path/to/your-project
bash /path/to/agentic-sdlc/agent-setup.sh                   # asks: new or existing project
bash /path/to/agentic-sdlc/agent-setup.sh --type existing   # non-interactive
```

Then:
1. Edit `.claude/skills/stack-*/SKILL.md` to match your stack's real commands, and delete the one you don't use.
2. Protect `main` on GitHub (Settings → Branches) so only you can merge.
3. Run `claude` in the project.

**Re-running is safe.** Framework files (`AGENTS.md`, agents, core skills) are upgraded, and any local edits are saved as `<file>.bak-<timestamp>`. Project files (tracking logs, registers, stack skills, `CLAUDE.md`, settings) are only created when missing, so your data and customizations are never overwritten. The installer also lists files from the previous framework version for you to remove.

## Roles

| Agent | Does | Never |
|---|---|---|
| **planner** | Captures requirement sources, writes BRD/PRD, technical design, API contract, change requests | Writes code |
| **developer** | Implements approved REQs test-first, updates traceability and CHANGELOG, opens PRs | Changes requirements or contracts |
| **reviewer** | Verifies a PR independently and runs the tests itself, then writes a review report | Edits code, approves, or merges |
| **onboarding** *(existing projects)* | Maps the existing codebase into as-built docs and REQs | Changes code |
| **you** | Approve documents, answer questions, accept CRs, merge, release | — |

## Lifecycle

```
0 Intake ─► 1 Requirements ─► [Gate A] ─► 2 Design + test cases ─► [Gate B] ─► 3 Build ─► 4 Verify ─► 5 Review ─► [Gate C] ─► 6 Release
 planner      planner          you         planner                  you        developer   reviewer    reviewer     you         regression run + you
```

- **Gate A:** you approve the PRD. **Gate B:** you approve the design, contract, test plan and test cases. **Gate C:** you merge the PR.
- Agents refuse to start a phase whose gate hasn't passed.
- Bugs (`BUG-###`) skip straight to a failing test and a fix. Changes to approved work go through a change request (`CR-###`) and a new document version.

## Day-to-day prompts

| You want to | Say |
|---|---|
| Record an email or chat | "Use the planner to capture this as a requirement source: *(paste)*" |
| Process dropped files | Put them in `requirements/inbox/`, then: "Use the planner to process the inbox." |
| Turn sources into requirements | "Use the planner to update the PRD from the new sources." |
| Approve a document | "PRD-v1.0 is approved. Record it." (Only you can approve. Agents never assume approval.) |
| Answer questions | "Answers: Q-003 option 1, Q-004 use 30 days." |
| Design | "Use the planner to write the technical design for PRD-v1.0." |
| Build | "Use the developer to implement REQ-004." |
| Review | "Use the reviewer to review PR 12." (records the test run and any defects) |
| Regression before release | "Run the release regression for 1.2.0 using manage-tests." |
| See status | "Summarize docs/04-delivery/traceability.md and the open questions." |

## What gets tracked, and where

| What | Where | ID |
|---|---|---|
| Every requirement source (email, chat, doc, meeting), with sender, original date, verbatim text and attachments | `requirements/register.md`, `requirements/sources/` | `SRC-###` |
| Requirements and acceptance criteria | `docs/02-product/PRD-vX.Y.md` | `REQ-###`, `AC-###.n` |
| Changes to approved requirements | `requirements/changes/` | `CR-###` |
| Current version and status of every document | `docs/index.md` | — |
| Status of every REQ/BUG: source → spec → design → code → tests → PR | `docs/04-delivery/traceability.md` | — |
| Questions and assumptions | `tracking/questions.md` | `Q-###` |
| Product and scope decisions | `tracking/decisions.md` | `DEC-###` |
| Architecture decisions | `docs/03-architecture/adr/` | `ADR-###` |
| Per-branch plan, log and test evidence | `tracking/progress/<branch>.md` | — |
| Timestamped event history | `tracking/activity.jsonl` | — |
| Test plan and test cases | `docs/04-delivery/test-plan-vX.Y.md`, `docs/04-delivery/test-cases/` | `TC-###.n` |
| Test runs, with a result per test case | `docs/04-delivery/test-runs/` | `RUN-…` |
| Defects | `docs/04-delivery/defects/` | `BUG-###` |
| Review reports | `docs/04-delivery/reviews/` | — |
| User-visible changes | `CHANGELOG.md` | — |

### Document versioning
Specs carry a header (version, status, owner, dates, approver, sources) and a revision history. The status flow is `Draft` → `In Review` → `Approved` → `Superseded`. **Approved files are frozen.** A change creates `PRD-v1.1.md` (additive) or `PRD-v2.0.md` (scope change), and every revision cites the SRC, CR or Q that caused it.

### Testing
Tests are designed from the acceptance criteria before any code is written, and every result is recorded:

| Step | Who | Record |
|---|---|---|
| Test plan and test cases. Every criterion gets a **positive** and a **failure** case (negative, boundary, error, security) | planner, approved by you at Gate B | `docs/04-delivery/test-plan-vX.Y.md`, `test-cases/TC-REQ-###.md` |
| An automated test for every case, named `REQ-004 TC-004.2 …`. New edge cases are added, never deleted | developer | Test code + the Automated test column |
| A verification run on every PR, with a result per test case and every failure classified | reviewer | `test-runs/RUN-…md` |
| A defect record for every product failure: reproduction, expected vs actual, evidence, root cause, fix, verification | reviewer → developer → reviewer | `defects/BUG-###-…md` |
| A full regression run before release | you or the main session | `test-runs/RUN-…-release-x.y.md` |

### Asking questions
Agents stop and ask when a requirement is ambiguous, sources conflict, a choice has product, security, cost or UX impact, or the work would touch approved documents. Each question goes into `tracking/questions.md` with options and a recommendation. Subagents can't prompt you directly, so they end their run with a **"Questions for the human"** list, and the main Claude session asks you. Non-blocking unknowns may proceed on an assumption marked `Assumed` for you to confirm later.

## Files installed

```text
AGENTS.md                      # rules for every agent (managed; brownfield guardrails added for existing projects)
CLAUDE.md                      # imports AGENTS.md, plus your project notes (yours)
CHANGELOG.md
.claude/
  settings.json                # denies gh pr merge, pushes to main/master, force-pushes (yours)
  agents/  planner.md  developer.md  reviewer.md  [onboarding.md]
  skills/
    intake-requirement/        # SKILL.md + source and change-request templates
    write-requirements/        # SKILL.md + BRD and PRD templates
    write-design/              # SKILL.md + tech-design, OpenAPI and ADR templates
    manage-tests/              # SKILL.md + test-plan, test-cases, test-run and defect templates
    implement-feature/
    review-pr/
    stack-node-express/        # example, edit to fit (yours)
    stack-react/               # example, edit to fit (yours)
docs/
  index.md  [00-onboarding/]  01-business/  02-product/  03-architecture/adr/  04-delivery/{traceability.md,test-cases/,test-runs/,defects/,reviews/}
requirements/
  register.md  inbox/  sources/attachments/  changes/
tracking/
  activity.jsonl  questions.md  decisions.md  progress/_template.md
[src/ tests/]                  # new projects only
```

### Adding your stack
Copy `.claude/skills/stack-node-express/` to `.claude/skills/stack-<name>/`, update the `name:` field, and replace the commands and conventions with your project's real ones (Python/FastAPI, Next.js, PHP/Laravel, ...). In an existing project, the onboarding agent creates one from what it finds in the codebase.

## Guardrails
- Repository files are the source of truth; chat memory is not.
- No merging and no pushing to `main` by agents. `.claude/settings.json` blocks the common commands, but deny rules match command prefixes only, so **GitHub branch protection is the real safeguard**.
- Raw emails, chats and documents are committed verbatim as the audit trail; only credentials and payment card numbers are redacted. Keep the repository private if sources contain personal data.
- IDs appear in every branch, commit and PR: `feat(REQ-012): ...`.
- Every acceptance criterion is covered by a test that names the REQ. No skipped or weakened tests.
- Existing projects: onboard first, make surgical changes, and add characterization tests before touching existing files.

## Developing this repository

```text
agent-setup.sh            # the installer
templates/
  AGENTS.core.md          # + AGENTS.brownfield.md → AGENTS.md
  CLAUDE.md
  framework/claude/       # → .claude/ (managed)
  brownfield/             # onboarding agent + docs/00-onboarding (existing projects)
  project/                # → project root (created only if missing)
tests/setup.test.sh       # run: bash tests/setup.test.sh
```

Template folders are named `claude/`, not `.claude/`, so Claude Code doesn't load them as this repository's own configuration. The repository uses the framework on itself: its `.claude/`, `docs/`, `requirements/` and `tracking/` folders are an installed copy and track its own development.

## License

This repository is provided as a general-purpose setup template for agent-driven SDLC workflows.
