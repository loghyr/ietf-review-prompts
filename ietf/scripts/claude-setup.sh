#!/bin/bash
#
# Claude Code setup for IETF Internet-Draft development
#
# Installs:
#   - IETF draft skill to ~/.claude/skills/ietf-draft/SKILL.md
#   - Slash commands to ~/.claude/commands/
#
# The prompts directory is determined from this script's location.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Review prompts directory: $PROMPTS_DIR"
echo ""

# --- Install Skill ---

SKILL_DIR="$HOME/.claude/skills/ietf-draft"
SKILL_FILE="$SKILL_DIR/SKILL.md"
SOURCE_SKILL="$PROMPTS_DIR/skills/ietf-draft.md"

if [ ! -f "$SOURCE_SKILL" ]; then
    echo "Error: Source skill file not found: $SOURCE_SKILL"
    exit 1
fi

mkdir -p "$SKILL_DIR"

sed "s|{{IETF_REVIEW_PROMPTS_DIR}}|$PROMPTS_DIR|g" "$SOURCE_SKILL" > "$SKILL_FILE"

echo "Installed skill:"
echo "  $SKILL_FILE"

# --- Install Slash Commands ---

COMMANDS_DIR="$HOME/.claude/commands"
SLASH_COMMANDS_SRC="$PROMPTS_DIR/slash-commands"

if [ ! -d "$SLASH_COMMANDS_SRC" ]; then
    echo "Warning: slash-commands directory not found, skipping"
else
    mkdir -p "$COMMANDS_DIR"

    echo ""
    echo "Installed slash commands:"

    for cmd_file in "$SLASH_COMMANDS_SRC"/*.md; do
        if [ -f "$cmd_file" ]; then
            cmd_name=$(basename "$cmd_file")
            sed "s|REVIEW_DIR|$PROMPTS_DIR|g" "$cmd_file" > "$COMMANDS_DIR/$cmd_name"
            echo "  /${cmd_name%.md}"
        fi
    done
fi

echo ""
echo "Setup complete!"
echo ""
echo "Available commands:"
echo "  /ietf-review   - Full draft review (structure, RFC 2119, XDR, IANA, security)"
echo "  /ietf-verify   - Pre-submission checklist"
echo "  /ietf-xdr      - XDR-focused review only"
echo ""
echo "The ietf-draft skill loads automatically in directories with draft-*.md files."
