#!/bin/bash
# ==========================================
# Agentic SDLC Framework installer
# ==========================================
# Run from the root of the project you want to set up:
#
#   bash /path/to/agentic-sdlc/agent-setup.sh [--type new|existing]
#
# Two kinds of files are installed from ./templates:
#   - Framework files (AGENTS.md, agents, core skills) are installed or upgraded.
#     If your local copy differs, it is saved as <file>.bak-<timestamp> first.
#   - Project files (tracking logs, registers, stack skills, settings, CLAUDE.md)
#     are created only when missing, so re-running never loses tracking data.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES="$SCRIPT_DIR/templates"
STAMP="$(date +%Y%m%d-%H%M%S)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CREATED=0
UPDATED=0
KEPT=0

usage() {
    cat <<'EOF'
Usage: bash agent-setup.sh [--type new|existing]

  --type new        New project: also creates src/ and tests/ folders
  --type existing   Existing project: adds brownfield guardrails and the onboarding agent
  -h, --help        Show this help

Without --type, the script asks.
EOF
}

die() {
    echo -e "${RED}$*${NC}" >&2
    exit 1
}

# ---------- arguments ----------
PROJECT_TYPE=""
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

[ -d "$TEMPLATES" ] || die "Templates folder not found at $TEMPLATES. Run this script from a full clone of agentic-sdlc."

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}   🤖 Agentic SDLC Framework                     ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo "Installing into: $(pwd)"

if [ -z "$PROJECT_TYPE" ]; then
    echo -e "Is this a ${GREEN}NEW${NC} project (greenfield) or an ${YELLOW}EXISTING${NC} project (brownfield)?"
    echo "1) New project (scaffold src/ and tests/)"
    echo "2) Existing project (preserve existing code, add onboarding)"
    read -r -p "Select option [1 or 2]: " PROJECT_TYPE
fi

case "$PROJECT_TYPE" in
    1|new) PROJECT_TYPE="new" ;;
    2|existing) PROJECT_TYPE="existing" ;;
    *) die "Invalid project type '$PROJECT_TYPE'. Use 1/new or 2/existing." ;;
esac

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
echo -e "\n📁 Project files (tracking, registers, stack skills, settings)..."

install_file "$TEMPLATES/CLAUDE.md" "CLAUDE.md" missing
install_tree "$TEMPLATES/project" missing
if [ "$PROJECT_TYPE" = "existing" ]; then
    install_tree "$TEMPLATES/brownfield/project" missing
else
    mkdir -p src/backend src/frontend tests/backend tests/e2e
fi

# ---------- checks ----------
WARNINGS=""
if ! grep -q "AGENTS.md" CLAUDE.md 2>/dev/null; then
    WARNINGS="$WARNINGS\n - CLAUDE.md does not reference AGENTS.md. Add the line '@AGENTS.md' to the top so Claude loads the rules."
fi

LEGACY=""
for f in .claude/agents/pm.md .claude/agents/architect.md .claude/agents/backend-dev.md \
         .claude/agents/ui-dev.md .claude/agents/qa-engineer.md \
         .claude/skills/create-brd.md .claude/skills/create-prd.md .claude/skills/create-design-doc.md \
         .claude/skills/implement-backend.md .claude/skills/implement-frontend.md \
         .claude/skills/run-qa-checks.md .claude/skills/backend-node-express.md \
         .claude/skills/frontend-react.md; do
    if [ -e "$f" ]; then
        LEGACY="$LEGACY $f"
    fi
done
if [ -n "$LEGACY" ]; then
    WARNINGS="$WARNINGS\n - Files from the previous framework version were found and are no longer used:\n  $LEGACY\n   Remove them with: git rm$LEGACY"
fi

# ---------- summary ----------
echo -e "\n${GREEN}✅ Agentic SDLC framework installed (${PROJECT_TYPE} project).${NC}"
echo "   Created: $CREATED · Updated: $UPDATED · Kept existing: $KEPT"
if [ -n "$WARNINGS" ]; then
    echo -e "\n${YELLOW}⚠️  Check:${NC}$WARNINGS"
fi
if [ "$UPDATED" -gt 0 ]; then
    echo -e "\n   Review the .bak-$STAMP files, keep any local changes you need, then delete them."
fi

echo -e "\n-------------------------------------------------"
echo -e "${BLUE}Next steps${NC}"
echo "1. Edit .claude/skills/stack-*/SKILL.md to match your real stack and commands (delete the one you don't use)."
echo "2. Protect 'main' on GitHub (Settings → Branches) so only you can merge."
echo "3. Start Claude Code in this folder (run: claude), then:"
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "   'Use the onboarding agent to map this codebase.'"
    echo "   After you approve the onboarding docs, capture new requirements with the planner."
else
    echo "   'Use the planner agent to capture this as a requirement source: <paste email / chat / notes>'"
    echo "   or drop files into requirements/inbox/ and say 'Use the planner agent to process the inbox.'"
fi
echo "-------------------------------------------------"
