# Questions and Assumptions Log

Agents ask instead of guessing (`AGENTS.md` §6). Every question and every working assumption is recorded here until the human answers it.

Find open items with `grep -n "Status: Open\|Status: Assumed" tracking/questions.md`.

Status: `Open` (waiting for an answer) · `Assumed` (work continued on the stated assumption, confirmation needed) · `Answered` · `Withdrawn`

<!-- Copy this block for each new question, newest at the bottom.

## Q-001 — <short title>
- **Raised:** YYYY-MM-DD by <role> (agent)
- **Related:** REQ-000, SRC-000
- **Blocking:** Yes | No
- **Status:** Open
- **Question:** <one clear question>
- **Context:** <why it matters and what depends on it>
- **Options:** 1. <recommended option> (recommended) 2. <alternative> 3. <alternative>
- **Assumption (if Assumed):** <what work continued on>
- **Answer:** Yes. Raw emails and chats must be committed to git (option 1). Sources are kept verbatim; only credentials and payment card numbers are redacted (DEC-002).
- **Answered by / on / via:** <name> / YYYY-MM-DD / chat | email SRC-000 | meeting SRC-000
-->

## Q-001 — Commit raw requirement sources to git?
- **Raised:** 2026-11-12 by main session (Claude)
- **Related:** REQ-003, SRC-001
- **Blocking:** No
- **Status:** Answered
- **Question:** Should captured emails, chats and documents (and their attachments) be committed to the repository?
- **Context:** Committing gives a full audit trail, but raw sources can contain personal data or confidential material.
- **Options:** 1. Commit, with redaction of secrets and personal data (recommended) 2. Commit only the SRC summary; keep originals outside the repo 3. Git-ignore `requirements/sources/attachments/`
- **Assumption (if Assumed):** Option 1, with redaction rules in the intake skill and a privacy note in the inbox README.
- **Answer:** Yes. Raw emails and chats must be committed to git (option 1). Sources are kept verbatim; only credentials and payment card numbers are redacted (DEC-002).
- **Answered by / on / via:** Project owner / 2026-11-13 / chat SRC-002

## Q-002 — Separate QA role?
- **Raised:** 2026-11-12 by main session (Claude)
- **Related:** REQ-001, DEC-001
- **Blocking:** No
- **Status:** Assumed
- **Question:** Is a separate QA agent needed, or is it enough for the developer to write the tests and the reviewer to verify them independently?
- **Context:** A separate QA agent adds independence in test design but adds an extra phase and PR for every feature.
- **Options:** 1. Developer writes the tests, reviewer verifies them and re-runs them (recommended for a solo developer) 2. Add a QA agent that writes E2E tests after the developer
- **Assumption (if Assumed):** Option 1.
- **Answer:**
- **Answered by / on / via:**

## Q-003 — Human acceptance (UAT) sign-off before merge?
- **Raised:** 2026-11-13 by main session (Claude)
- **Related:** REQ-008, SRC-003
- **Blocking:** No
- **Status:** Assumed
- **Question:** Besides the reviewer's recorded test run, should you personally sign off each REQ (user acceptance testing) before it's merged?
- **Context:** UAT catches "works as specified but not what I meant", but adds a manual step to every feature.
- **Options:** 1. Optional: you can add a UAT entry to the RUN, but merging doesn't require it (recommended for a solo developer) 2. Required for every REQ: the reviewer can't report "Ready for human" without it 3. Required only for `Must` REQs with UI
- **Assumption (if Assumed):** Option 1.
- **Answer:**
- **Answered by / on / via:**

## Q-004 — Numeric code-coverage threshold?
- **Raised:** 2026-11-13 by main session (Claude)
- **Related:** REQ-008, SRC-003
- **Blocking:** No
- **Status:** Assumed
- **Question:** Should the exit criteria include a minimum line/branch coverage percentage (e.g. 80%)?
- **Context:** The gate today is requirement coverage: every AC has positive and failure test cases that pass. A percentage adds a code-level safety net but depends on the stack's tooling.
- **Options:** 1. No percentage; requirement coverage is the gate (recommended) 2. Set a percentage in each project's test plan
- **Assumption (if Assumed):** Option 1. A project can still add a percentage in its own test plan.
- **Answer:**
- **Answered by / on / via:**
