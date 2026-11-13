# Changelog

All notable changes to this project are recorded here, following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/). Every entry references its REQ, BUG or CR ID.

## [Unreleased]

### Added
- Planner, developer and reviewer agents, plus onboarding for existing projects (REQ-001)
- Skills in the `.claude/skills/<name>/SKILL.md` format with BRD, PRD, source-record, change-request, technical-design, OpenAPI and ADR templates (REQ-002)
- Requirement intake from email, chat, documents and meetings: an `SRC-###` source register, an inbox and change requests. Raw sources are committed verbatim; only credentials are redacted (REQ-003, DEC-002)
- Document versioning rules, a standard header and the `docs/index.md` document register (REQ-004)
- Gated lifecycle, ID scheme, traceability status board, questions and decisions logs, progress template and activity-ledger schema (REQ-005)
- Ask-when-in-doubt protocol, including how subagents return their questions (REQ-006)
- Test management: test plan, documented test cases with a positive and a failure case per acceptance criterion, RUN reports with a result per test case, and defect records from failure to verified fix (`manage-tests` skill) (REQ-008)
- Installer does every setup step: stack menu or `--stack node-express|react|both|other`, blank `stack-project` template, `--remove-legacy` (or a prompt), `.gitkeep` scaffold for new projects, install record in `.claude/sdlc.json` and `framework_installed`/`framework_upgraded` ledger events, re-runs reuse the recorded type. It never runs git or changes GitHub (REQ-009, DEC-004)
- Installer options `--type new|existing` and `--help`, deny rules in `.claude/settings.json`, and `tests/setup.test.sh` (REQ-007)

### Changed
- `agent-setup.sh` installs from `templates/` instead of inline heredocs. Re-running upgrades framework files (backing up local changes) and never overwrites tracking data or customized stack skills (REQ-007)

### Fixed
- Re-running the installer no longer re-creates a stack skill you deleted (BUG-001)

### Removed
- The `pm`, `architect`, `backend-dev`, `ui-dev` and `qa-engineer` agents and the flat `.claude/skills/*.md` files. The installer lists them in existing projects for removal (REQ-001, REQ-002)
