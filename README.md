# Plan Requests

A Claude Code skill to save output from "plan mode" in markdown files, so plans can be easily edited, resumed, and verified after implementation.

## Installation

Run `./install.sh` to install (or update) this skill in `~/.claude/skills`. Restart Claude Code sessions after installing.

## Usage

```
/plan-request <command> [plan-name]
```

### Commands

| Command | Description |
|---|---|
| `create <name>` | Create a new plan request. Captures plan mode output if available. |
| `list` | List all plan requests with their status. |
| `execute <name>` | Begin or resume implementing a plan. Tracks progress across sessions. |
| `verify <name>` | Check if plan requirements have been implemented in the codebase. |
| `complete <name>` | Verify all requirements and mark the plan as complete. |
| `delete <name>` | Delete a plan request (with confirmation). |

### Workflow

1. **Plan** — Use Claude's plan mode to design a feature, or write a plan from scratch
2. **Create** — `/plan-request create my-feature` saves the plan to `.plans/my-feature.md`
3. **Edit** — Refine the plan file in your editor (requirements, steps, verification)
4. **Execute** — `/plan-request execute my-feature` implements the plan, tracking progress
5. **Resume** — Start a new Claude session, run execute again to pick up where you left off
6. **Verify** — `/plan-request verify my-feature` checks requirements against the codebase
7. **Complete** — `/plan-request complete my-feature` marks done (only if all requirements pass)

## Plan File Format

Plan requests live in `.plans/` as markdown files with YAML frontmatter:

```markdown
---
title: My Feature
status: draft
created: 2025-01-15
updated: 2025-01-15
---

## Context
Why this change is needed.

## Requirements
- [ ] First requirement
- [ ] Second requirement

## Implementation Plan
### Step 1: ...

## Verification
How to test the implementation.

## Session Log
### 2025-01-15
- Started execution, completed step 1
```

### Status Lifecycle

- **draft** — Plan created, not yet being implemented
- **in-progress** — Implementation underway
- **complete** — All requirements verified and implemented
