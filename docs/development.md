# Development

## Checks

Requires Zsh:

```sh
for file in vault-environments.plugin.zsh install.zsh uninstall.zsh; do
  zsh -n "$file"
done
zsh tests/smoke.zsh
```

One smoke-test script checks profile operations, URL/argument/stdin/exit forwarding for both CLIs and local installation, reinstallation and uninstallation. It uses a temporary home and two tiny CLI stand-ins; no Python, test framework or network access is needed.

Ten lines in the smoke test check completion registration and profile candidates using stubbed `compadd`. CLI delegation, interactive Tab behavior and Zsh prefix filtering are not covered by this test.

## Structure

- `vault-environments.plugin.zsh`: `ve`, profile file operations, direct CLI delegation and `_ve` completion.
- `install.zsh`: find `vault` or `bao` in `PATH` (prefer `vault`), copy or download the scripts, save the choice and add or replace the marked completion/source block; stop with an installation hint if neither exists.
- `uninstall.zsh`: delete the marked block and installed scripts.

Configuration is plain text: `config` contains the global CLI choice and `profiles/<name>` contains one URL. The wrapper changes only the selected CLI's address variable, in a subprocess, and forwards `"$@"`. It has no persistent shell state or command-specific behavior.

## Configuration and Local Installation

- Configuration: `${VE_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/vault-environments}`.
- Installed scripts: `${XDG_DATA_HOME:-$HOME/.local/share}/vault-environments`.
- Startup file: `${ZDOTDIR:-$HOME}/.zshrc`.

Use the same environment overrides for installation, shell usage and uninstallation. Edit `config` to change the CLI, or a profile file to change its URL. Profile names accept lowercase ASCII letters, digits and hyphens; management command names are reserved. Creation does not overwrite an existing profile.

For local installation, run `zsh install.zsh` in the checkout. It copies the plugin and uninstaller to the installation directory. The checkout can then be removed. Both local and curl installation replace existing installed scripts. Login and token storage remain the CLI's responsibility; VE does not isolate tokens or provide a custom logout.

## Completion

The installer adds a marked startup block: initialize `compinit` if `compdef` is unavailable, register the selected CLI through `bashcompinit` and `complete -o nospace -C` if no handler exists, then source VE. Existing CLI handlers and key bindings are unchanged. Reinstallation replaces the block; uninstallation removes it.

For manual sourcing, load VE after `compinit` or Oh My Zsh initialization and CLI registration. Without `compdef`, VE skips registration. Registered CLI handlers are reused with local `words` and `CURRENT`.

See [VE-001](requirements/ve-001-profile-url-wrapper.md), [VE-002](requirements/ve-002-tab-completion.md), [VE-ADR-001](adrs/ve-adr-001-initial-implementation-as-zsh-plugin.md) and [VE-ADR-002](adrs/ve-adr-002-use-native-zsh-completion.md).
