# Repository Guidance

## Checks

Run the CI checks with Zsh, not Bash:

```sh
for file in vault-environments.plugin.zsh install.zsh uninstall.zsh; do
  zsh -n "$file" || exit 1
done
zsh tests/smoke.zsh
```

- The smoke test uses a disposable HOME and CLI stand-ins; no server is needed. Its Bao-only installation check assumes no system `vault` remains in PATH after the stand-in is removed.
- Completion checks stub `compadd`; they do not verify CLI delegation, interactive Tab behavior or Zsh prefix filtering. Keep tests proportional; VE-002 permits omitting interactive tests needing more than ten lines.

## Execution Boundaries

- `ve` is a sourced shell function, not an executable. Forward `"$@"`, stdin and exit status unchanged; set only the selected CLI's address variable in a subprocess. No active profile, token isolation or login/session logic.
- Profiles contain one URL; `config` contains the global CLI choice. Read both as data, never source them. Configuration precedence: `VE_CONFIG_HOME`, otherwise `${XDG_CONFIG_HOME:-$HOME/.config}/vault-environments`.
- Installation prefers Vault when both CLIs exist. It copies local scripts or downloads them when piped from curl; do not introduce runtime dependencies on the checkout.
- All installer-owned startup lines end in ` # vault-environments`. Installation replaces them; uninstallation removes them while preserving unrelated startup content and configuration. Startup path is `${ZDOTDIR:-$HOME}/.zshrc`.
- Completion order: `compinit` → CLI registration → source VE. The installer initializes missing completion and registers the selected CLI through `bashcompinit`/`complete -C`, preserving existing handlers. The plugin alone skips registration without `compdef`.
- `_ve` delegates through `_normal` with local `words` and `CURRENT`; do not maintain Vault/Bao command definitions in VE.

## Documentation and Workflow

- Minimize implementation and test code; prefer native Zsh features. Additional frameworks are allowed when they substantially simplify the implementation. Keep tests proportional to the feature.
- Write facts, not filler. Omit repetition and unnecessary explanations.
- Keep both READMEs short and aligned: user commands only; implementation/setup details belong in `docs/development.md`.
- Consult `.opencode/skills/doc-requirements-write/` and `.opencode/skills/doc-adr-write/` for documentation rules/templates. Requirements describe needs; ADRs record technical decisions and reference constraints rather than repeat requirements.
- Release and commit workflows live in `.opencode/skills/release-*/SKILL.md`; they are local-only and prohibit pushing. Use them when requested, not automatically.
