#!/bin/bash
# Tests for agent-setup.sh. Run: bash tests/setup.test.sh
# Each scenario installs into a fresh temporary folder.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/agent-setup.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }
check() { # check "<description>" <command...>
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then ok "$desc"; else fail "$desc"; fi
}

install() { # install <dir> <type>
    mkdir -p "$1"
    (cd "$1" && bash "$SCRIPT" --type "$2") >"$1.log" 2>&1
}

frontmatter_name() { # first "name:" value in a file's frontmatter
    sed -n '2,10p' "$1" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//'
}

valid_skills() { # every skill dir has SKILL.md whose name matches the dir
    local dir="$1" d
    for d in "$dir"/.claude/skills/*/; do
        [ -f "$d/SKILL.md" ] || return 1
        [ "$(frontmatter_name "$d/SKILL.md")" = "$(basename "$d")" ] || return 1
        grep -q '^description: .\{40,\}' "$d/SKILL.md" || return 1
    done
}

valid_agents() { # every agent file's name matches its file name and has a description
    local dir="$1" f
    for f in "$dir"/.claude/agents/*.md; do
        [ "$(frontmatter_name "$f")" = "$(basename "$f" .md)" ] || return 1
        grep -q '^description: ' "$f" || return 1
    done
}

skills_referenced_exist() { # every skill an agent names is installed
    local dir="$1" s
    for s in $(grep -ho '`[a-z-]*`' "$dir"/.claude/agents/*.md | tr -d '`' | sort -u); do
        case "$s" in
            intake-requirement|write-requirements|write-design|implement-feature|review-pr)
                [ -f "$dir/.claude/skills/$s/SKILL.md" ] || return 1 ;;
        esac
    done
}

valid_json() { python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$1"; }
valid_yaml() { python3 -c 'import sys
try:
    import yaml
except ImportError:
    sys.exit(0)
yaml.safe_load(open(sys.argv[1]))' "$1"; }

echo "1. New project"
N="$TMP/new"
check "installer exits 0" install "$N" new
for f in AGENTS.md CLAUDE.md CHANGELOG.md docs/index.md docs/04-delivery/traceability.md \
         requirements/register.md requirements/inbox/README.md tracking/questions.md \
         tracking/decisions.md tracking/activity.jsonl tracking/progress/_template.md \
         .claude/settings.json .claude/agents/planner.md .claude/agents/developer.md \
         .claude/agents/reviewer.md; do
    check "creates $f" test -f "$N/$f"
done
for d in src/backend src/frontend tests/backend tests/e2e docs/03-architecture/adr \
         docs/04-delivery/reviews requirements/sources/attachments requirements/changes; do
    check "creates $d/" test -d "$N/$d"
done
check "no onboarding agent" test ! -e "$N/.claude/agents/onboarding.md"
check "no brownfield guardrails in AGENTS.md" sh -c "! grep -q 'Existing-project guardrails' '$N/AGENTS.md'"
check "CLAUDE.md imports AGENTS.md" grep -q '^@AGENTS.md' "$N/CLAUDE.md"
check "skills are valid (folder/SKILL.md, matching name, description)" valid_skills "$N"
check "agents are valid (matching name, description)" valid_agents "$N"
check "every core skill named by an agent is installed" skills_referenced_exist "$N"
check "settings.json is valid JSON" valid_json "$N/.claude/settings.json"
check "settings.json denies gh pr merge" grep -q 'gh pr merge' "$N/.claude/settings.json"
check "API contract template is valid YAML" valid_yaml "$N/.claude/skills/write-design/api-contract-template.yaml"
check "no template folder named .claude leaked from templates/" sh -c "! find '$ROOT/templates' -name .claude | grep -q ."

echo "2. Existing project"
E="$TMP/existing"
mkdir -p "$E/src" && echo "keep me" > "$E/src/app.js"
check "installer exits 0" install "$E" existing
check "adds onboarding agent" test -f "$E/.claude/agents/onboarding.md"
check "adds brownfield guardrails to AGENTS.md" grep -q 'Existing-project guardrails' "$E/AGENTS.md"
check "creates docs/00-onboarding/" test -d "$E/docs/00-onboarding"
check "does not create src/backend" test ! -d "$E/src/backend"
check "leaves existing source untouched" grep -q 'keep me' "$E/src/app.js"
check "agents are valid" valid_agents "$E"

echo "3. Re-running keeps project data"
echo '{"ts":"2026-01-01T00:00:00Z","actor":"human","event":"test","ref":"REQ-001"}' >> "$N/tracking/activity.jsonl"
echo '| REQ-001 | Login | Must | SRC-001 | PRD-v1.0 | | | | | Approved | 2026-01-01 |' >> "$N/docs/04-delivery/traceability.md"
echo "custom command" >> "$N/.claude/skills/stack-react/SKILL.md"
echo "my note" >> "$N/CLAUDE.md"
echo "local rule" >> "$N/AGENTS.md"
check "re-run exits 0" install "$N" new
check "activity ledger kept" grep -q '"event":"test"' "$N/tracking/activity.jsonl"
check "traceability rows kept" grep -q 'REQ-001 | Login' "$N/docs/04-delivery/traceability.md"
check "customized stack skill kept" grep -q 'custom command' "$N/.claude/skills/stack-react/SKILL.md"
check "CLAUDE.md kept" grep -q 'my note' "$N/CLAUDE.md"
check "changed AGENTS.md restored from template" sh -c "! grep -q 'local rule' '$N/AGENTS.md'"
check "changed AGENTS.md backed up" sh -c "grep -l 'local rule' '$N'/AGENTS.md.bak-* | grep -q ."

echo "4. Upgrade from the previous framework version"
L="$TMP/legacy"
mkdir -p "$L/.claude/agents" "$L/.claude/skills"
echo "old" > "$L/.claude/agents/pm.md"
echo "old" > "$L/.claude/skills/create-prd.md"
check "installer exits 0" install "$L" new
check "warns about legacy files" grep -q 'previous framework version' "$L.log"
check "does not delete legacy files" test -f "$L/.claude/agents/pm.md"

echo "5. Bad input"
check "rejects unknown --type" sh -c "cd '$TMP' && ! bash '$SCRIPT' --type nonsense"
check "rejects unknown option" sh -c "cd '$TMP' && ! bash '$SCRIPT' --bogus"
check "--help exits 0" bash "$SCRIPT" --help

echo
echo "Passed: $PASS  Failed: $FAIL"
[ "$FAIL" -eq 0 ]
