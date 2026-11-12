# Requirements inbox

Drop raw requirement input here, then ask the planner to **"process the inbox"**:

- Emails: `.eml` exports, or the text copied into a `.md` or `.txt` file (include From, Date and Subject)
- Chat: exported threads or copied messages (include who said what, and when)
- Documents: `.docx`, `.pdf`, `.md`, spreadsheets
- Meeting or call notes

The planner records each item as `requirements/sources/SRC-###-*.md`, moves the original into `requirements/sources/attachments/SRC-###/`, and logs it in `requirements/register.md`. Anything left in this folder has not been processed yet.

You can also skip the inbox: paste the email or chat straight into Claude and say "capture this as a requirement source".

> **Privacy:** these files are committed to git. Remove anything that shouldn't live in the repository (personal data, secrets) before dropping it here, or ask the planner to redact it.
