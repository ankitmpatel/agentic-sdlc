#!/bin/bash
# ==========================================
# Agentic SDLC Framework installer
# ==========================================
# Run from the root of the project you want to set up:
#
#   bash /path/to/agentic-sdlc/agent-setup.sh [--type new|existing] [--stack ...] [--remove-legacy]
#
# Everything the framework needs is set up by this script: agents, skills, rules,
# tracking files, folders, the stack skill and (for new projects) the scaffold.
#
#   - Framework files (AGENTS.md, agents, core skills) are installed or upgraded.
#     If your local copy differs, it is saved as <file>.bak-<timestamp> first.
#   - Project files (tracking logs, registers, test records, settings, CLAUDE.md,
#     stack skills) are created only when missing, so re-running never loses data.
#   - The install is recorded in .claude/sdlc.json and tracking/activity.jsonl.
#   - The script never runs git and never changes GitHub settings (DEC-004).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES="$SCRIPT_DIR/templates"
STAMP="$(date +%Y%m%d-%H%M%S)"
NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
RECORD=".claude/sdlc.json"
LEDGER="tracking/activity.jsonl"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CREATED=0
UPDATED=0
KEPT=0

# Files from framework v1 that this version replaces.
LEGACY_FILES=".claude/agents/pm.md .claude/agents/architect.md .claude/agents/backend-dev.md
.claude/agents/ui-dev.md .claude/agents/qa-engineer.md
.claude/skills/create-brd.md .claude/skills/create-prd.md .claude/skills/create-design-doc.md
.claude/skills/implement-backend.md .claude/skills/implement-frontend.md
.claude/skills/run-qa-checks.md .claude/skills/backend-node-express.md
.claude/skills/frontend-react.md"

usage() {
    cat <<'EOF'
Usage: bash agent-setup.sh [options]

  --type new|existing   new: also scaffolds src/ and tests/
                        existing: adds brownfield guardrails and the onboarding agent
                        Re-runs reuse the type recorded in .claude/sdlc.json.
  --stack VALUE         Stack skill to install: node-express | react | both | other
                        ("other" installs a blank stack-project template to fill in).
                        Asked interactively when no stack skill exists yet.
  --remove-legacy       Remove files from the previous framework version (otherwise
                        they are listed, or you are asked).
  -h, --help            Show this help

Without options the script asks what it needs. It never runs git or changes GitHub.
EOF
}

die() {
    echo -e "${RED}$*${NC}" >&2
    exit 1
}

is_interactive() { [ -t 0 ]; }

# ---------- arguments ----------
PROJECT_TYPE=""
STACK_CHOICE=""
REMOVE_LEGACY=0
while [ $# -gt 0 ]; do
    case "$1" in
        --type)
            [ $# -ge 2 ] || die "--type needs a value: new or existing"
            PROJECT_TYPE="$2"
            shift 2
            ;;
        --type=*)
            PROJECT_TYPE="${1#--type=}"
            shift
            ;;
        --stack)
            [ $# -ge 2 ] || die "--stack needs a value: node-express, react, both or other"
            STACK_CHOICE="$2"
            shift 2
            ;;
        --stack=*)
            STACK_CHOICE="${1#--stack=}"
            shift
            ;;
        --remove-legacy)
            REMOVE_LEGACY=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "Unknown option: $1"
            ;;
    esac
done

# stack_dirs <choice> — prints the stack skill folders for a menu choice or --stack value
stack_dirs() {
    case "$1" in
        1|node-express) echo "stack-node-express" ;;
        2|react) echo "stack-react" ;;
        3|both) echo "stack-node-express stack-react" ;;
        4|other) echo "stack-project" ;;
        *) return 1 ;;
    esac
}

# Validate everything before touching any file.
if [ -n "$STACK_CHOICE" ]; then
    stack_dirs "$STACK_CHOICE" >/dev/null || die "Invalid --stack '$STACK_CHOICE'. Use node-express, react, both or other."
fi

[ -d "$TEMPLATES" ] || die "Templates folder not found at $TEMPLATES. Run this script from a full clone of agentic-sdlc."
FRAMEWORK_VERSION="$(tr -d '[:space:]' < "$TEMPLATES/VERSION")"

# Read a string field from the install record (no JSON tool needed).
record_field() {
    [ -f "$RECORD" ] || return 0
    sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" "$RECORD" | head -1
}

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}   🤖 Agentic SDLC Framework ${FRAMEWORK_VERSION}${NC}"
echo -e "${BLUE}=================================================${NC}"
echo "Installing into: $(pwd)"

# ---------- project type ----------
if [ -z "$PROJECT_TYPE" ]; then
    PROJECT_TYPE="$(record_field project_type)"
    if [ -n "$PROJECT_TYPE" ]; then
        echo "Project type: $PROJECT_TYPE (recorded in $RECORD)"
    elif is_interactive; then
        echo -e "Is this a ${GREEN}NEW${NC} project (greenfield) or an ${YELLOW}EXISTING${NC} project (brownfield)?"
        echo "1) New project (scaffold src/ and tests/)"
        echo "2) Existing project (preserve existing code, add onboarding)"
        read -r -p "Select option [1 or 2]: " PROJECT_TYPE || true
    else
        die "No project type: pass --type new or --type existing (no terminal to ask, and no $RECORD from an earlier run)."
    fi
fi

case "$PROJECT_TYPE" in
    1|new) PROJECT_TYPE="new" ;;
    2|existing) PROJECT_TYPE="existing" ;;
    *) die "Invalid project type '$PROJECT_TYPE'. Use 1/new or 2/existing." ;;
esac

# ---------- stack ----------
HAS_STACK_SKILL=0
for d in .claude/skills/stack-*/; do
    if [ -d "$d" ]; then
        HAS_STACK_SKILL=1
    fi
done

STACKS=""
if [ -n "$STACK_CHOICE" ]; then
    STACKS="$(stack_dirs "$STACK_CHOICE")"
elif [ "$HAS_STACK_SKILL" -eq 0 ]; then
    if is_interactive; then
        echo -e "\nWhich stack does this project use? (agents read its build and test commands from the stack skill)"
        echo "1) Node.js + Express backend"
        echo "2) React frontend"
        echo "3) Both"
        echo "4) Other (blank template to fill in, or let the onboarding agent fill it)"
        read -r -p "Select option [1-4, default 4]: " STACK_CHOICE || true
        [ -n "$STACK_CHOICE" ] || STACK_CHOICE=4
        STACKS="$(stack_dirs "$STACK_CHOICE")" || die "Invalid stack option '$STACK_CHOICE'. Use 1-4."
    else
        STACKS="stack-project"
        echo "Stack: none given and no terminal to ask; installing the blank stack-project template (use --stack to choose)."
    fi
fi

# ---------- helpers ----------

# Template folders use "claude/" so Claude Code doesn't load them as this repo's
# own config; they are installed to ".claude/".
target_path() {
    case "$1" in
        claude/*) echo ".$1" ;;
        *) echo "$1" ;;
    esac
}

# install_file <src> <dest> <managed|missing>
install_file() {
    local src="$1" dest="$2" mode="$3"
    mkdir -p "$(dirname "$dest")"
    if [ ! -e "$dest" ]; then
        cp "$src" "$dest"
        CREATED=$((CREATED + 1))
        echo -e "   ${GREEN}+${NC} $dest"
    elif [ "$mode" = "missing" ]; then
        KEPT=$((KEPT + 1))
    elif cmp -s "$src" "$dest"; then
        : # already up to date
    else
        cp "$dest" "$dest.bak-$STAMP"
        cp "$src" "$dest"
        UPDATED=$((UPDATED + 1))
        echo -e "   ${YELLOW}~${NC} $dest (previous copy saved as $dest.bak-$STAMP)"
    fi
}

# install_tree <template root> <managed|missing>
install_tree() {
    local root="$1" mode="$2" rel
    [ -d "$root" ] || return 0
    while IFS= read -r rel; do
        rel="${rel#./}"
        install_file "$root/$rel" "$(target_path "$rel")" "$mode"
    done < <(cd "$root" && find . -type f | sort)
}

# ---------- framework files (installed / upgraded) ----------
echo -e "\n🧠 Framework files (AGENTS.md, agents, skills)..."

AGENTS_TMP="$(mktemp)"
trap 'rm -f "$AGENTS_TMP"' EXIT
cat "$TEMPLATES/AGENTS.core.md" > "$AGENTS_TMP"
if [ "$PROJECT_TYPE" = "existing" ]; then
    cat "$TEMPLATES/AGENTS.brownfield.md" >> "$AGENTS_TMP"
fi
install_file "$AGENTS_TMP" "AGENTS.md" managed

install_tree "$TEMPLATES/framework" managed
if [ "$PROJECT_TYPE" = "existing" ]; then
    install_tree "$TEMPLATES/brownfield/framework" managed
fi

# ---------- project files (created only if missing) ----------
echo -e "\n📁 Project files (tracking, registers, test records, settings, stack, scaffold)..."

install_file "$TEMPLATES/CLAUDE.md" "CLAUDE.md" missing
install_tree "$TEMPLATES/project" missing
if [ "$PROJECT_TYPE" = "existing" ]; then
    install_tree "$TEMPLATES/brownfield/project" missing
else
    install_tree "$TEMPLATES/greenfield/project" missing
fi
for s in $STACKS; do
    install_file "$TEMPLATES/stacks/$s/SKILL.md" ".claude/skills/$s/SKILL.md" missing
done

# ---------- files from the previous framework version ----------
LEGACY=""
for f in $LEGACY_FILES; do
    if [ -e "$f" ]; then
        LEGACY="$LEGACY $f"
    fi
done
LEGACY_NOTE=""
if [ -n "$LEGACY" ]; then
    if [ "$REMOVE_LEGACY" -eq 0 ] && is_interactive; then
        echo -e "\nThese files are from the previous framework version and are no longer used:\n  $LEGACY"
        read -r -p "Remove them now? [y/N] " answer || true
        case "$answer" in
            y|Y|yes|YES) REMOVE_LEGACY=1 ;;
        esac
    fi
    if [ "$REMOVE_LEGACY" -eq 1 ]; then
        for f in $LEGACY; do
            rm -f "$f"
            echo -e "   ${RED}-${NC} $f (removed: previous framework version)"
        done
    else
        LEGACY_NOTE="\n - Files from the previous framework version were found and are no longer used:\n  $LEGACY\n   Re-run with --remove-legacy to remove them."
    fi
fi

# ---------- install record ----------
INSTALLED_AT="$(record_field installed_at)"
EVENT="framework_upgraded"
if [ -z "$INSTALLED_AT" ]; then
    INSTALLED_AT="$NOW"
    EVENT="framework_installed"
fi
STACK_JSON=""
STACK_LIST=""
for d in .claude/skills/stack-*/; do
    if [ -d "$d" ]; then
        name="$(basename "$d")"
        STACK_JSON="${STACK_JSON:+$STACK_JSON, }\"$name\""
        STACK_LIST="${STACK_LIST:+$STACK_LIST,}$name"
    fi
done
cat > "$RECORD" <<EOF
{
  "framework": "agentic-sdlc",
  "framework_version": "$FRAMEWORK_VERSION",
  "project_type": "$PROJECT_TYPE",
  "stacks": [$STACK_JSON],
  "installed_at": "$INSTALLED_AT",
  "updated_at": "$NOW"
}
EOF
echo "{\"ts\":\"$NOW\",\"actor\":\"installer\",\"event\":\"$EVENT\",\"ref\":\"$RECORD\",\"note\":\"agentic-sdlc $FRAMEWORK_VERSION, type $PROJECT_TYPE, stacks ${STACK_LIST:-none}, created $CREATED, updated $UPDATED\"}" >> "$LEDGER"
echo "   • recorded in $RECORD and $LEDGER ($EVENT)"

# ---------- checks ----------
WARNINGS="$LEGACY_NOTE"
if ! grep -q "AGENTS.md" CLAUDE.md 2>/dev/null; then
    WARNINGS="$WARNINGS\n - CLAUDE.md does not reference AGENTS.md. Add the line '@AGENTS.md' to the top so Claude loads the rules."
fi

# ---------- summary ----------
echo -e "\n${GREEN}✅ Agentic SDLC framework ${FRAMEWORK_VERSION} installed (${PROJECT_TYPE} project).${NC}"
echo "   Created: $CREATED · Updated: $UPDATED · Kept existing: $KEPT · Stack: ${STACK_LIST:-none}"
if [ -n "$WARNINGS" ]; then
    echo -e "\n${YELLOW}⚠️  Check:${NC}$WARNINGS"
fi
if [ "$UPDATED" -gt 0 ]; then
    echo -e "\n   Review the .bak-$STAMP files, move any local rules you need into CLAUDE.md, then delete them."
fi

echo -e "\n-------------------------------------------------"
echo -e "${BLUE}Next steps${NC}"
echo "1. Fill in the real commands in .claude/skills/stack-*/SKILL.md (in an existing project the onboarding agent can do it)."
echo "2. Protect 'main' on GitHub (Settings → Branches) so only you can merge. This script never changes GitHub."
echo "3. Keep the repository private if requirement sources contain personal data (raw emails and chats are committed)."
echo "4. Commit the installed files on a branch (this script never runs git), start Claude Code here (run: claude), then:"
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "   'Use the onboarding agent to map this codebase.'"
    echo "   After you approve the onboarding docs, capture new requirements with the planner."
else
    echo "   'Use the planner agent to capture this as a requirement source: <paste email / chat / notes>'"
    echo "   or drop files into requirements/inbox/ and say 'Use the planner agent to process the inbox.'"
fi
echo "-------------------------------------------------"
