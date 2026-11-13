---
bug_id: BUG-001
title: Re-running the installer re-creates deleted stack skills
severity: Minor
status: Fixed
reported: 2026-11-13
reported_by: main session (Claude)
found_in: Manual re-install of this repo (before RUN reports existed)
test_case: TC-007.11
req: REQ-007
commit: abcfbde^ (f200585)
environment: macOS 12.7.6, GNU bash 3.2.57
fixed_in: abcfbde
verified_in:
---

# BUG-001 — Re-running the installer re-creates deleted stack skills

## Steps to reproduce
1. Install with `bash agent-setup.sh --type new`.
2. Delete `.claude/skills/stack-node-express/` (the installer's own next steps say to delete the unused one).
3. Run the installer again.

## Expected result
The deleted stack skill stays deleted (AC-007.6).

## Actual result
`.claude/skills/stack-node-express/SKILL.md` is created again (`+ .claude/skills/stack-node-express/SKILL.md` in the output).

## Evidence
```text
   + .claude/skills/stack-node-express/SKILL.md
   + .claude/skills/stack-react/SKILL.md
   Created: 2 · Updated: 3 · Kept existing: 18
```

## Impact
Every upgrade brings back unused stack skills, which can give the developer and reviewer agents the wrong stack conventions.

## Root cause
Project files are "create if missing". A deleted file counts as missing, so the stack skill examples came back.

## Fix
`agent-setup.sh` sets `HAS_STACK_SKILL` before installing and skips `claude/skills/stack-*` templates when any `stack-*` skill already exists. Covered by TC-007.11.

## Verification
<Pending: RUN on this branch.>

## History
| Date | Status | By | Note |
|---|---|---|---|
| 2026-11-13 | Open | main session (Claude) | Found while re-installing into this repo |
| 2026-11-13 | Fixed | main session (Claude) | Commit abcfbde; TC-007.11 added |
