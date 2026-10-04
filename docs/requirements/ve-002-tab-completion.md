---
state: implemented
---

# VE-002: Tab Completion

## Context

Tab completion extends the Zsh interface defined in [VE-001](ve-001-profile-url-wrapper.md).

## Assumptions

- Zsh completion is initialized during startup, by the installer setup or the user's configuration.

## Open Questions

- None

## Requirements

### Initial Argument Completion
**Type:** Functional
**Description:** VE must complete the first argument with profile names and management commands.
**Acceptance Criteria:**
- Completion for `ve <Tab>` offers existing profile names and `create`, `list`, `show`, `remove` and `help`.
- Candidates match the entered prefix; unique matches can be completed.
- Repeated Tab presses follow the user's Zsh completion configuration.

### Profile Management Argument Completion
**Type:** Functional
**Description:** VE must complete profile names for `show` and `remove`.
**Acceptance Criteria:**
- Completion for `ve show <Tab>` and `ve remove <Tab>` offers existing profile names.
- Candidates match the entered prefix.
- Candidates reflect the current contents of the configured profile directory.

### Delegated CLI Completion
**Type:** Functional
**Description:** VE must complete CLI commands and arguments when existing CLI completion can be reused with a simple integration.
**Acceptance Criteria:**
- With reusable CLI completion, `ve <profile> <Tab>` and subsequent arguments offer that CLI's candidates.
- Completion uses only the configured CLI.
- Without reusable CLI completion, VE completion and command execution remain usable.
- VE need not define Vault or OpenBao commands, flags or arguments.

### Zsh and Oh My Zsh Compatibility
**Type:** Constraint
**Description:** VE completion must support standalone Zsh and Oh My Zsh.
**Acceptance Criteria:**
- With completion enabled and the documented load order, both environments provide the same VE candidates.
- Oh My Zsh is optional.
- Unrelated command completion and Tab-key bindings remain unchanged.
- The supported startup order is documented.
- Installation enables completion for VE and the selected CLI without a separate setup command; existing CLI handlers are preserved.

### Completion Dependency Constraints
**Type:** Constraint
**Description:** VE completion must add no software dependencies.
**Acceptance Criteria:**
- Standard Zsh features and completion helpers are allowed.
- No additional package, framework or completion service is required.
- CLI completion may reuse support installed in the user's shell.
- Profile and management-command completion requires no server connection.
**References:** [VE-ADR-002](../adrs/ve-adr-002-use-native-zsh-completion.md)

### Completion Test Complexity
**Type:** Constraint
**Description:** Completion tests must not introduce a complex interactive test setup.
**Acceptance Criteria:**
- Interactive tests are added only for a necessary check not covered by non-interactive tests.
- Interactive tests may be omitted if their test code requires more than ten lines.
- Omitted checks are documented as verification limits, not reported as passed.
