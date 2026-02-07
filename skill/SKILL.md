---
name: plan-request
description: "Save and track Claude Code plans"
user-invocable: true
argument-hint: "<create|list|execute|verify|complete|delete> [plan-name]"
---

# Plan Request Skill

Manage saved plan request files in the `.plans/` directory. Plan requests are markdown files with YAML frontmatter that capture feature plans, track implementation progress, and verify completion — like pull requests, but the artifact is the plan.

## Argument Handling

Parse `$ARGUMENTS` to determine the subcommand and plan name:
- First word is the subcommand: `create`, `list`, `execute`, `verify`, `complete`, or `delete`
- Remaining words form the plan name (convert to kebab-case for the filename)
- If `$ARGUMENTS` is empty, show the help output below
- If the subcommand is not recognized, show the help output below
- If a plan name is required but missing (`create`, `execute`, `verify`, `complete`, `delete`), show an error message (e.g., "Missing plan name") followed by the help output

## Help Output

When no subcommand is provided, display:

```
Plan Request — manage saved plan files in .plans/

Usage: /plan-request <command> [plan-name]

Commands:
  create <name>    Create a new plan request (captures plan mode output if available)
  list             List all plan requests with status
  execute <name>   Begin or resume implementing a plan
  verify <name>    Check if plan requirements are implemented
  complete <name>  Verify and mark a plan as complete
  delete <name>    Delete a plan request
```

## Subcommands

### create

1. Convert the plan name argument to a kebab-case filename slug
2. Create the `.plans/` directory if it does not exist (use `mkdir -p`)
3. Read the template from `template.md` in the skill's base directory
4. Populate the YAML frontmatter:
   - `title`: Use the plan name argument as a human-readable title (convert kebab-case to Title Case)
   - `status`: `draft`
   - `created`: today's date in YYYY-MM-DD format
   - `updated`: today's date in YYYY-MM-DD format
5. If the conversation context contains a plan from a recent plan mode session (look for plan content in prior messages), incorporate that content into the appropriate template sections:
   - Plan context/rationale goes into **Context**
   - Concrete deliverables and acceptance criteria go into **Requirements** as `- [ ]` checkbox items
   - Implementation steps go into **Implementation Plan**
   - Testing/verification instructions go into **Verification**
6. Write the populated template to `.plans/<slug>.md`
7. Confirm creation and display the file path

### list

1. Use Glob to find all `.plans/*.md` files
2. If no files found, report that no plan requests exist and suggest using `/plan-request create`
3. For each file, use Read to parse the YAML frontmatter (between the opening and closing `---` lines)
4. Extract: `title`, `status`, `updated`
5. Display a formatted table:

```
Plan Requests:

| Plan            | Status      | Updated    |
|-----------------|-------------|------------|
| Auth System     | in-progress | 2025-01-15 |
| Search Feature  | draft       | 2025-01-14 |
| Bug Fix Login   | complete    | 2025-01-13 |
```

### execute

1. Read `.plans/<name>.md`
2. If the file does not exist, report the error and suggest `/plan-request list`
3. Update the YAML frontmatter:
   - Set `status` to `in-progress` (if not already)
   - Set `updated` to today's date
4. Append a new entry to the **Session Log** section:
   ```
   ### YYYY-MM-DD
   - Starting execution session
   ```
5. Write the updated file
6. Read and understand the full plan:
   - Review the **Context** for background
   - Review the **Requirements** checklist — identify which items are already checked (`[x]`) and which remain (`[ ]`)
   - Review the **Implementation Plan** for the approach
7. Begin implementing the unchecked requirements, following the Implementation Plan steps
8. As each requirement is completed, update the plan file:
   - Change `- [ ]` to `- [x]` for the completed requirement
   - Add notes to the current Session Log entry about what was done
   - Update the `updated` date in frontmatter
9. If the session ends before all requirements are complete, add a summary to the Session Log noting what was accomplished and what remains

### verify

1. Read `.plans/<name>.md`
2. If the file does not exist, report the error
3. Parse all requirement items from the **Requirements** section (lines matching `- [ ]` or `- [x]`)
4. For each requirement:
   - Use Glob, Grep, and Read to search the codebase for evidence of implementation
   - Determine if the requirement has been fulfilled based on the code
5. Display results as a verification report:
   ```
   Verification: auth-system

   [PASS] User login endpoint exists
         Found in src/routes/auth.ts:15
   [PASS] Password hashing with bcrypt
         Found in src/utils/auth.ts:8
   [FAIL] Rate limiting on login attempts
         No implementation found

   Result: 2/3 requirements verified
   ```
6. Do NOT modify the plan file status — this is a read-only check

### complete

1. Run the **verify** logic (same as above)
2. If any requirements are marked `[FAIL]`:
   - Report which requirements are not yet implemented
   - Do NOT change the plan status
   - Suggest using `/plan-request execute <name>` to continue implementation
3. If ALL requirements are `[PASS]`:
   - Update the YAML frontmatter: set `status` to `complete`, set `updated` to today's date
   - Check off any remaining unchecked requirement boxes (`- [ ]` → `- [x]`)
   - Add a completion entry to the Session Log:
     ```
     ### YYYY-MM-DD
     - Plan completed. All requirements verified.
     ```
   - Write the updated file
   - Display a completion summary

### delete

1. Check if `.plans/<name>.md` exists
2. If the file does not exist, report the error and suggest `/plan-request list`
3. Read the file and display the plan title and status from the YAML frontmatter
4. Ask the user to confirm deletion
5. If confirmed, delete the file using Bash `rm`
6. Confirm deletion to the user

## Important Behaviors

- Always create the `.plans/` directory before writing if it does not exist
- Preserve all existing content when updating plan files — only modify frontmatter fields, checkbox states, and append to Session Log
- Use kebab-case for filenames (e.g., `auth-system.md`, `search-feature.md`)
- When the plan name argument contains spaces, convert to kebab-case (e.g., "auth system" becomes `auth-system`)
- If a `.plans/<name>.md` file already exists when running `create`, warn the user and ask before overwriting
