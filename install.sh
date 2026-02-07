#!/bin/bash
set -e

SKILL_DIR="$HOME/.claude/skills/plan-request"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill"

mkdir -p "$(dirname "$SKILL_DIR")"
rm -rf "$SKILL_DIR"
cp -r "$SOURCE_DIR" "$SKILL_DIR"

echo "Installed plan-request skill to $SKILL_DIR"
echo "Restart Claude Code to activate."
