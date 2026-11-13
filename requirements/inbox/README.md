# Requirements inbox

Drop raw requirement input here, then ask the planner to **"process the inbox"**:

- Emails: `.eml` exports, or the text copied into a `.md` or `.txt` file (include From, Date and Subject)
- Chat: exported threads or copied messages (include who said what, and when)
- Documents: `.docx`, `.pdf`, `.md`, spreadsheets
- Meeting or call notes

The planner records each item as `requirements/sources/SRC-###-*.md`, moves the original into `requirements/sources/attachments/SRC-###/`, and logs it in `requirements/register.md`. Anything left in this folder has not been processed yet.

You can also skip the inbox: paste the email or chat straight into Claude and say "capture this as a requirement source".

> **Committed as the permanent record.** Sources are committed to git exactly as received, including names, addresses, signatures and quoted replies. The planner redacts only passwords, API keys, tokens and payment card numbers. Anyone with access to the repository can read them, so keep the repository private if sources contain personal or confidential information.
