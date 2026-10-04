---
state: implemented
---

# VE-001: Profile URL Wrapper

## Context

VE selects a server profile and delegates commands to Vault or OpenBao in Zsh on Ubuntu.

## Assumptions

- Zsh and the selected CLI are installed by the user.

## Open Questions

- None

## Requirements

### Explicit Profile
**Type:** Functional
**Description:** Each CLI invocation must select an existing profile using `ve <profile> [command] [arguments...]`.
**Acceptance Criteria:**
- There is no active or default profile.
- A missing, invalid or unreadable profile, or an empty profile URL, produces an error without executing the CLI.

### Target URL
**Type:** Functional
**Description:** The selected profile must supply the CLI process's server address.
**Acceptance Criteria:**
- Vault receives the profile URL as `VAULT_ADDR`; OpenBao receives it as `BAO_ADDR`, replacing any inherited value of that variable.
- The calling shell's environment remains unchanged.
- Explicit CLI flags, including `-address`, retain their native behavior.

### CLI Delegation
**Type:** Functional
**Description:** VE must forward the requested command to the selected CLI unchanged.
**Acceptance Criteria:**
- Argument values, order and boundaries, stdin, stdout, stderr, exit status and Ctrl+C behavior are preserved.
- An invocation without command arguments invokes the CLI without arguments.
- Login, token storage, authentication and all other CLI behavior remain native; VE performs no automatic login, session management, command interpretation or additional probe calls.

### CLI Selection
**Type:** Functional
**Description:** VE must support one globally configured CLI, either `vault` or `bao`.
**Acceptance Criteria:**
- `zsh install.zsh` checks for `vault` and `bao` in `PATH` and automatically selects an available CLI; if both are available, it selects `vault`.
- If neither CLI is available, installation stops before changing files and asks the user to install Vault or OpenBao first.
- The choice can be changed without reinstalling.
- An invalid choice or a configured CLI missing from `PATH` produces an error without switching CLIs.
- VE does not install dependencies or validate product-version output.

### Profile Storage
**Type:** Constraint
**Description:** Each profile must contain only its server URL as plain text.
**Acceptance Criteria:**
- A profile has one nonempty URL line and no metadata, generation ID or credentials managed by VE.
- Profile contents are treated as data, not executable shell code.

### Profile Creation
**Type:** Functional
**Description:** `ve create <profile>` must create a named profile by asking only for its URL.
**Acceptance Criteria:**
- Names are nonempty and contain only lowercase ASCII letters, digits and hyphens; `create`, `list`, `show`, `remove` and `help` are reserved.
- Names are used as supplied, without normalization.
- Invalid names, missing URLs and existing profiles produce an error; existing profiles are not overwritten.
- Creation does not require a server connection or login.

### Profile Inspection
**Type:** Functional
**Description:** Users must be able to list profiles and read their stored URLs.
**Acceptance Criteria:**
- `ve list` lists profile names.
- `ve show <profile>` outputs the profile URL.

### Profile Removal
**Type:** Functional
**Description:** `ve remove <profile>` must delete the named local profile.
**Acceptance Criteria:**
- Other profiles remain unchanged.
- Removing an absent profile succeeds without changes.

### Shell Integration
**Type:** Functional
**Description:** Installation and uninstallation must manage one marked setup block in the user's Zsh startup configuration.
**Acceptance Criteria:**
- Installation adds or replaces the block; repeated installation leaves one setup block with one VE source line.
- Uninstallation removes the block and installed scripts, preserving profiles, CLI selection and unrelated startup content.
- `${ZDOTDIR:-$HOME}/.zshrc` is used; no legacy-entry migration is required.

### Download Installation
**Type:** Functional
**Description:** Users must be able to install VE with one curl command without keeping a repository checkout.
**Acceptance Criteria:**
- `curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/install.zsh | zsh` downloads and installs the plugin and uninstaller.
- Installation from a local checkout with `zsh install.zsh` remains supported.
- Installed scripts are stored under `${XDG_DATA_HOME:-$HOME/.local/share}/vault-environments`; repeated installation replaces them.
- A failed script download stops installation before changing installed scripts, configuration or shell integration.

### Implementation Simplicity
**Type:** Constraint
**Description:** VE must minimize implementation and test complexity.
**Acceptance Criteria:**
- Native Zsh features are preferred.
- Additional frameworks or dependencies are allowed when they substantially simplify the implementation; the benefit is documented in an ADR.
- Test scope and setup remain proportional to the feature.
