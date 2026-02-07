# Plan Requests

Plan requests are persistent markdown files that capture feature plans, track implementation progress across Claude sessions, and verify completion. Like pull requests, but the artifact is the plan rather than code.

## Installation

Clone this repo and run the install script:

```sh
git clone https://github.com/jdamcd/plan-requests.git
cd plan-requests
./install.sh
```

To update after pulling changes, run `./install.sh` again. Restart Claude Code after installing.

## Usage

```
/plan-request <command> [plan-name]
```

### Commands

| Command | Description |
|---|---|
| `create <name>` | Create a new plan request. Captures plan mode output if available. |
| `list` | List all plan requests with their status. |
| `show <name>` | Display the full contents of a plan request. |
| `execute <name>` | Begin or resume implementing a plan. Tracks progress across sessions. |
| `verify <name>` | Check if plan requirements have been implemented in the codebase. |
| `complete <name>` | Verify all requirements and mark the plan as complete. |

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
