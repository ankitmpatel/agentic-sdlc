---
doc_id: TEST-PLAN
title: Test Plan — agentic-sdlc framework v2
version: 1.0
status: Approved
owner: Project owner
created: 2026-11-13
updated: 2026-11-13
approved_by: Project owner
approved_on: 2026-11-13
supersedes:
prd: PRD-v1.0
design: docs/00-onboarding/architecture-map-v1.0.md
sources: [PRD-v1.0, SRC-003]
---

# Test Plan — agentic-sdlc framework v2

## Revision history
| Version | Date | Author | Change | Reason |
|---|---|---|---|---|
| 1.0 | 2026-11-13 | main session (Claude) | Initial draft | SRC-003, REQ-008 |
| 1.0 | 2026-11-13 | Project owner | Approved | SRC-004 |

## 1. Scope
**In scope:** REQ-001 … REQ-008 (PRD-v1.0): what the installer produces, and the rule text in the installed files.
**Out of scope:** how agents behave at runtime (whether an agent actually asks, versions documents, or records runs). This is checked by the reviewer on each PR using `review-pr`, not by this suite.

## 2. Test levels and tools
| Level | What it covers | Tool / command | Owner |
|---|---|---|---|
| Scenario (integration) | Installer runs in temporary folders: new, existing, re-run, legacy upgrade, invalid input | `bash tests/setup.test.sh` | developer |
| Static | Script syntax | `bash -n agent-setup.sh tests/setup.test.sh` | developer |
| Manual | Rule content that a grep can't meaningfully verify (TC-003.4, TC-003.5, TC-004.3) | Steps in the test-case files | reviewer |

## 3. Environments and test data
macOS with Bash 3.2 (the oldest supported shell) and Python 3 for JSON/YAML checks. PyYAML is optional: TC-002.3 is skipped without it. All test data is created in `mktemp -d` folders and deleted afterwards.

## 4. Entry criteria
- `bash -n` passes for both scripts.

## 5. Exit criteria
- Every acceptance criterion has a positive and a failure test case, or a recorded N/A reason
- 0 failed checks; any skip has a stated reason
- Manual cases executed and recorded in the RUN
- No open Blocker or Major defect

## 6. Regression suite
The whole of `tests/setup.test.sh` (under 10 s) runs on every PR and before every release.

## 7. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| Static greps prove the rule text exists, not that agents follow it | Medium | Reviewer checklist on every PR; future: an eval suite that runs the agents |
| TC-002.3 skipped where PyYAML is absent | Low | Install PyYAML in CI |
