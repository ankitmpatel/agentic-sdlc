#!/bin/bash
# Tests for agent-setup.sh. Run: bash tests/setup.test.sh
# Every check is named after its test case in docs/04-delivery/test-cases/TC-REQ-###.md.
# Each scenario installs into a fresh temporary folder.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/agent-setup.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0
FAIL=0
SKIP=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }
skip() { SKIP=$((SKIP + 1)); echo "  - $1 (skipped: $2)"; }
check() { # check "<TC-ID description>" <command...>
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then ok "$desc"; else fail "$desc"; fi
}
all_files() { # all_files <dir> <relative paths...>
    local dir="$1" f; shift
    for f in "$@"; do [ -f "$dir/$f" ] || return 1; done
}
all_dirs() {
    local dir="$1" d; shift
    for d in "$@"; do [ -d "$dir/$d" ] || return 1; done
}

install() { # install <dir> <type>
    mkdir -p "$1"
    (cd "$1" && bash "$SCRIPT" --type "$2") >"$1.log" 2>&1
}

frontmatter_name() {
    sed -n '2,10p' "$1" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//'
}

valid_skills() { # every skill dir has SKILL.md whose name matches the dir and a real description
    local dir="$1" d
    for d in "$dir"/.claude/skills/*/; do
        [ -f "$d/SKILL.md" ] || return 1
        [ "$(frontmatter_name "$d/SKILL.md")" = "$(basename "$d")" ] || return 1
        grep -q '^description: .\{40,\}' "$d/SKILL.md" || return 1
    done
}

valid_agents() {
    local dir="$1" f
    for f in "$dir"/.claude/agents/*.md; do
        [ "$(frontmatter_name "$f")" = "$(basename "$f" .md)" ] || return 1
        grep -q '^description: ' "$f" || return 1
    done
}

core_skills_installed() { # every core skill an agent names is installed
    local dir="$1" s
    for s in $(grep -ho '`[a-z-]*`' "$dir"/.claude/agents/*.md | tr -d '`' | sort -u); do
        case "$s" in
            intake-requirement|write-requirements|write-design|manage-tests|implement-feature|review-pr)
                [ -f "$dir/.claude/skills/$s/SKILL.md" ] || return 1 ;;
        esac
    done
}

agents_end_with_questions() {
    local f
    for f in "$1"/.claude/agents/*.md; do grep -qi 'questions for the human' "$f" || return 1; done
}

spec_templates_have_header() {
    local f
    for f in "$1"/.claude/skills/write-requirements/BRD-template.md \
             "$1"/.claude/skills/write-requirements/PRD-template.md \
             "$1"/.claude/skills/write-design/tech-design-template.md \
             "$1"/.claude/skills/manage-tests/test-plan-template.md; do
        grep -q '^version: ' "$f" && grep -q '^status: ' "$f" && grep -q '^approved_by:' "$f" \
            && grep -q 'Revision history' "$f" || return 1
    done
}

valid_json() { python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$1"; }
have_pyyaml() { python3 -c 'import yaml' 2>/dev/null; }
valid_yaml() { python3 -c 'import yaml,sys; yaml.safe_load(open(sys.argv[1]))' "$1"; }

# ------------------------------------------------------------------
echo "Scenario 1 — new project"
N="$TMP/new"
check "TC-007.1 --type new runs non-interactively and exits 0" install "$N" new
check "TC-007.1 new project gets src/ and tests/ scaffolding" all_dirs "$N" src/backend src/frontend tests/backend tests/e2e
check "TC-001.1 planner, developer and reviewer agents installed" all_files "$N" .claude/agents/planner.md .claude/agents/developer.md .claude/agents/reviewer.md
check "TC-001.2 no onboarding agent in a new project" test ! -e "$N/.claude/agents/onboarding.md"
check "TC-001.4 agent names match file names and have descriptions" valid_agents "$N"
check "TC-002.1 skills use <name>/SKILL.md with matching name and description" valid_skills "$N"
check "TC-002.2 every core skill named by an agent is installed" core_skills_installed "$N"
if have_pyyaml; then
    check "TC-002.3 API contract template is valid YAML" valid_yaml "$N/.claude/skills/write-design/api-contract-template.yaml"
else
    skip "TC-002.3 API contract template is valid YAML" "PyYAML not installed"
fi
check "TC-002.5 BRD, PRD, source, CR, tech-design, OpenAPI and ADR templates installed" all_files "$N" .claude/skills/write-requirements/BRD-template.md .claude/skills/write-requirements/PRD-template.md .claude/skills/intake-requirement/source-template.md .claude/skills/intake-requirement/change-request-template.md .claude/skills/write-design/tech-design-template.md .claude/skills/write-design/api-contract-template.yaml .claude/skills/write-design/adr-template.md
check "TC-002.4 no folder named .claude inside templates/" sh -c "! find '$ROOT/templates' -name .claude | grep -q ."
check "TC-003.1 requirement register, inbox, sources and changes created" sh -c "test -f '$N/requirements/register.md' && test -f '$N/requirements/inbox/README.md' && test -d '$N/requirements/sources/attachments' && test -d '$N/requirements/changes'"
check "TC-003.2 intake skill requires committing raw sources" grep -q 'Raw sources are always committed' "$N/.claude/skills/intake-requirement/SKILL.md"
check "TC-003.2 AGENTS.md requires committing raw sources" grep -q 'committed verbatim' "$N/AGENTS.md"
check "TC-003.3 no .gitignore excludes requirement sources" sh -c "! grep -qs 'requirements' '$N/.gitignore'"
check "TC-004.1 document register docs/index.md created" test -f "$N/docs/index.md"
check "TC-004.2 spec templates have version, status, approval and revision history" spec_templates_have_header "$N"
check "TC-005.1 tracking files created" all_files "$N" docs/04-delivery/traceability.md tracking/questions.md tracking/decisions.md tracking/activity.jsonl tracking/progress/_template.md CHANGELOG.md
check "TC-005.1 ADR and review folders created" all_dirs "$N" docs/03-architecture/adr docs/04-delivery/reviews
check "TC-005.2 AGENTS.md defines gates and the ledger events" sh -c "grep -q 'Gate A' '$N/AGENTS.md' && grep -q 'test_run_recorded' '$N/AGENTS.md'"
check "TC-006.1 AGENTS.md has the ask-don't-assume protocol" grep -q "Ask, don't assume" "$N/AGENTS.md"
check "TC-006.2 every agent ends with Questions for the human" agents_end_with_questions "$N"
check "TC-007.10 settings.json is valid JSON and denies gh pr merge" sh -c "python3 -c 'import json,sys; json.load(open(sys.argv[1]))' '$N/.claude/settings.json' && grep -q 'gh pr merge' '$N/.claude/settings.json'"
check "TC-007.12 CLAUDE.md imports AGENTS.md" grep -q '^@AGENTS.md' "$N/CLAUDE.md"
check "TC-008.1 manage-tests skill with plan, case, run and defect templates" all_files "$N" .claude/skills/manage-tests/SKILL.md .claude/skills/manage-tests/test-plan-template.md .claude/skills/manage-tests/test-cases-template.md .claude/skills/manage-tests/test-run-template.md .claude/skills/manage-tests/defect-template.md
check "TC-008.2 rules require a positive and a failure case per AC" sh -c "grep -q 'one \*\*failure\*\* test case' '$N/AGENTS.md' && grep -q 'Coverage rule' '$N/.claude/skills/manage-tests/SKILL.md'"
check "TC-008.3 test-run and defect templates record per-TC results, failures and reproduction" sh -c "grep -q 'Results by test case' '$N/.claude/skills/manage-tests/test-run-template.md' && grep -q 'Classification' '$N/.claude/skills/manage-tests/test-run-template.md' && grep -q 'Steps to reproduce' '$N/.claude/skills/manage-tests/defect-template.md'"
check "TC-008.4 test-cases, test-runs and defects folders created" all_dirs "$N" docs/04-delivery/test-cases docs/04-delivery/test-runs docs/04-delivery/defects

# ------------------------------------------------------------------
echo "Scenario 2 — existing project"
E="$TMP/existing"
mkdir -p "$E/src" && echo "keep me" > "$E/src/app.js"
check "TC-007.2 --type existing exits 0" install "$E" existing
check "TC-001.3 onboarding agent added" test -f "$E/.claude/agents/onboarding.md"
check "TC-001.4 agent names match file names (existing)" valid_agents "$E"
check "TC-007.2 brownfield guardrails and docs/00-onboarding added" sh -c "grep -q 'Existing-project guardrails' '$E/AGENTS.md' && test -d '$E/docs/00-onboarding'"
check "TC-007.2 new projects do not get brownfield guardrails" sh -c "! grep -q 'Existing-project guardrails' '$N/AGENTS.md'"
check "TC-007.3 existing source untouched and no src/backend scaffold" sh -c "grep -q 'keep me' '$E/src/app.js' && test ! -d '$E/src/backend'"
check "TC-007.13 identical re-run exits 0" install "$E" existing
check "TC-007.13 unchanged framework files are not backed up" sh -c "! find '$E' -name '*.bak-*' | grep -q ."

# ------------------------------------------------------------------
echo "Scenario 3 — re-running keeps project data"
echo '{"ts":"2026-01-01T00:00:00Z","actor":"human","event":"test","ref":"REQ-001"}' >> "$N/tracking/activity.jsonl"
echo '| REQ-001 | Login | Must | SRC-001 | PRD-v1.0 | | | | | Approved | 2026-01-01 |' >> "$N/docs/04-delivery/traceability.md"
echo "custom command" >> "$N/.claude/skills/stack-react/SKILL.md"
echo "my note" >> "$N/CLAUDE.md"
echo "local rule" >> "$N/AGENTS.md"
echo "# RUN-1 recorded" > "$N/docs/04-delivery/test-runs/RUN-20260101-0000-pr1.md"
echo "# BUG-001 open" > "$N/docs/04-delivery/defects/BUG-001-example.md"
rm -rf "$N/.claude/skills/stack-node-express"
check "TC-007.4 re-run exits 0" install "$N" new
check "TC-007.4 activity ledger and traceability rows kept" sh -c "grep -q '\"event\":\"test\"' '$N/tracking/activity.jsonl' && grep -q 'REQ-001 | Login' '$N/docs/04-delivery/traceability.md'"
check "TC-007.4 customized stack skill and CLAUDE.md kept" sh -c "grep -q 'custom command' '$N/.claude/skills/stack-react/SKILL.md' && grep -q 'my note' '$N/CLAUDE.md'"
check "TC-007.5 changed AGENTS.md restored and the local copy backed up" sh -c "! grep -q 'local rule' '$N/AGENTS.md' && grep -l 'local rule' '$N'/AGENTS.md.bak-* | grep -q ."
check "TC-007.11 deleted stack skill is not re-created (BUG-001)" test ! -e "$N/.claude/skills/stack-node-express"
check "TC-008.5 recorded test runs and defects are kept on re-run" sh -c "grep -q 'RUN-1 recorded' '$N/docs/04-delivery/test-runs/RUN-20260101-0000-pr1.md' && grep -q 'BUG-001 open' '$N/docs/04-delivery/defects/BUG-001-example.md'"

# ------------------------------------------------------------------
echo "Scenario 4 — upgrade from the previous framework version"
L="$TMP/legacy"
mkdir -p "$L/.claude/agents" "$L/.claude/skills"
echo "old" > "$L/.claude/agents/pm.md"
echo "old" > "$L/.claude/skills/create-prd.md"
check "TC-007.6 installer exits 0 over legacy files" install "$L" new
check "TC-007.6 legacy files reported, not deleted" sh -c "grep -q 'previous framework version' '$L.log' && test -f '$L/.claude/agents/pm.md'"

# ------------------------------------------------------------------
echo "Scenario 5 — invalid input"
check "TC-007.7 unknown --type rejected with non-zero exit" sh -c "cd '$TMP' && ! bash '$SCRIPT' --type nonsense"
check "TC-007.8 unknown option rejected with non-zero exit" sh -c "cd '$TMP' && ! bash '$SCRIPT' --bogus"
check "TC-007.8 --type without a value rejected" sh -c "cd '$TMP' && ! bash '$SCRIPT' --type"
check "TC-007.9 --help exits 0 and prints usage" sh -c "bash '$SCRIPT' --help | grep -q 'Usage:'"

echo
echo "Passed: $PASS  Failed: $FAIL  Skipped: $SKIP"
[ "$FAIL" -eq 0 ]
