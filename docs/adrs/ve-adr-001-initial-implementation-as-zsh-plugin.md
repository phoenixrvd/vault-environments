---
state: accepted
---

# VE-ADR-001: Small Zsh Wrapper

## Decision

Implement [VE-001](../requirements/ve-001-profile-url-wrapper.md) in three files:

- `vault-environments.plugin.zsh`: the `ve` function, trivial profile file operations and CLI delegation.
- `install.zsh`: copy or download the plugin and uninstaller, then add or replace one marked source line in `.zshrc`.
- `uninstall.zsh`: remove that line and the installed scripts.

A profile file contains only its URL; a separate file contains the global CLI choice. Invocation reads these values, sets the CLI's address variable in a subprocess and forwards the original arguments.

Configuration lives in `${VE_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/vault-environments}`: `profiles/<name>` holds the URL and `config` holds `vault` or `bao`. Installation selects an available CLI from `PATH`, preferring `vault` when both exist, or asks the user to install one if neither exists. Profile creation uses a non-overwriting file write; configuration is read as data.

Installed scripts live in `${XDG_DATA_HOME:-$HOME/.local/share}/vault-environments`. Local installation copies them from the checkout. A piped installer downloads them from `phoenixrvd/vault-environments` on branch `main` to a temporary directory before installing. The source line points to the installed copy, so the checkout is not needed afterward.

## Rationale and Consequences

This directly supports the requested Zsh workflow with a single source line. No module framework, session state, token handling or command parsing is needed. Authentication and other native behavior remain with Vault/OpenBao. The wrapper must be loaded in Zsh to use `ve`.

This decision replaces the previous shell-session-based design and its VE-002 requirements.
