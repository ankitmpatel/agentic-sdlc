---
name: intake-requirement
description: Capture a requirement source — an email, chat message or thread, document, meeting or call notes, ticket, or files dropped in requirements/inbox/ — as a numbered SRC record before it is used, classify it (new requirement, change, clarification, answer, defect), raise change requests and questions. Use whenever new requirement input, stakeholder feedback, a change request, or an answer to an open question arrives.
---
# Intake a requirement source

**Goal:** nothing becomes a requirement until its source is recorded, dated, attributed and traceable.

Templates in this folder: `source-template.md`, `change-request-template.md`.

## 1. Find the input
- Text pasted into the conversation, such as an email body or chat log
- A file path the human gave you
- Files in `requirements/inbox/` (for "process the inbox", handle every file except `README.md`, one `SRC` per file or thread)

If one input contains several unrelated threads, create one `SRC` per thread.

## 2. Create the source record
1. Next ID: `grep -hoE 'SRC-[0-9]{3}' requirements/register.md | sort -u | tail -1`, then add 1. Start at `SRC-001`.
2. Create `requirements/sources/SRC-###-<short-slug>.md` from `source-template.md`.
3. Fill in the metadata from the source itself:
   - **channel:** `email` | `chat` | `document` | `meeting` | `call` | `ticket` | `other`
   - **from / participants:** names and roles as they appear in the source
   - **received:** the original date of the message or document, not today's date. If unknown, write `unknown` and say so.
   - **reference:** subject line, thread or channel name, document title and version, or ticket number
4. **Original content:** paste it verbatim. You may remove only signatures, legal footers and quoted earlier replies that are already captured; note what you removed. **Redact** passwords, tokens, payment data and other secrets, and note the redaction.
5. **Original files:** move them out of the inbox into `requirements/sources/attachments/SRC-###/` with `git mv` (or `mv` if untracked). For `.docx`, `.pdf` and other binary files, extract the text into the record if you can. Otherwise summarize it and say the summary is not verbatim.

## 3. Analyse
For each statement that asks for, changes or constrains something:
- Search the current PRD and `docs/04-delivery/traceability.md` for related REQs.
- Classify the statement:

| Type | Meaning | Next step |
|---|---|---|
| New | Something not covered yet | Candidate REQ for `write-requirements` |
| Clarification | Adds detail to a REQ that is not yet approved | Update the draft PRD via `write-requirements` |
| Change | Alters an `Approved` REQ or document | Raise a CR (step 4) |
| Answer | Answers a `Q-###` | Update the question (step 5) |
| Defect | Existing behavior is wrong | Add a `BUG-###` row to traceability with status `Proposed` |
| Info | Context only, nothing to act on | Record and link only |

- Note **conflicts** with other sources or with approved documents, and **ambiguities** (vague words such as "fast", "simple" or "all users", missing numbers, unclear owners).

Write the analysis into the record's "Extracted items" table.

## 4. Change requests
For each Change, create `requirements/changes/CR-###-<slug>.md` from `change-request-template.md`. Give the affected REQs and documents, and the impact on scope, design, code, tests and schedule. Set `Status: Proposed`, log `cr_raised`, and list the CR as needing a human decision. Only an `Accepted` CR may lead to a new document version.

## 5. Answers
Update the question in `tracking/questions.md`: add the answer, who gave it, the date, and `via SRC-###`. Set `Status: Answered` and log `question_answered`. If the item was `Blocked` only because of this question, restore its previous status.

## 6. Register and log
1. Add a row to `requirements/register.md`. Set the status to `Analysed`, or `Incorporated` once a document uses it.
2. Raise a question (`AGENTS.md` §6) for every conflict or ambiguity.
3. Log `source_captured` for each SRC, plus `cr_raised` and `question_raised` events as they occur.

**Do not write REQs in this skill.** `write-requirements` does that and cites the SRC IDs.
