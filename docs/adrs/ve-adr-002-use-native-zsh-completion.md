---
state: accepted
---

# VE-ADR-002: Use Native Zsh Completion

## Status

accepted

## Context

- Architecture: [VE-ADR-001](ve-adr-001-initial-implementation-as-zsh-plugin.md).
- Constraints: [Shell compatibility](../requirements/ve-002-tab-completion.md#zsh-and-oh-my-zsh-compatibility), [dependencies](../requirements/ve-002-tab-completion.md#completion-dependency-constraints).
- CLI scope: [Delegated CLI Completion](../requirements/ve-002-tab-completion.md#delegated-cli-completion).
- Test scope: [Completion Test Complexity](../requirements/ve-002-tab-completion.md#completion-test-complexity).
- Vault and OpenBao provide CLI completion via `-autocomplete-install`.
- Oh My Zsh's Vault plugin registers `complete -o nospace -C vault vault` through Zsh's `bashcompinit`.
- Zsh's `_bash_complete` derives `COMP_LINE` and `COMP_POINT` from `words`, `CURRENT` and the completion prefix, then invokes the CLI.
- Local check: OpenBao 2.7.1 returned `kv` subcommands through `COMP_LINE`/`COMP_POINT` and through `_bash_complete` with an adapted `ve dev kv <Tab>` context. Vault was not installed.

## Decision

- Register a Zsh completion function for `ve` with `compdef`; use native helpers such as `compadd`.
- The installer adds a startup block that runs `compinit` only if `compdef` is unavailable. Keep key bindings unchanged.
- For CLI delegation, replace `ve <profile>` with the configured CLI in local `words`, decrement `CURRENT`, and dispatch to the registered handler through `_normal`.
- The startup block registers the selected CLI through `bashcompinit` and `complete -o nospace -C` only if no handler exists. Do not run `-autocomplete-install` or overwrite existing CLI registrations. The plugin itself does not initialize completion.
- Delegate only if an existing handler needs no more than a context adapter. Do not implement a CLI-completion subsystem.

## Rationale

- Zsh provides the registration and candidate helpers.
- Oh My Zsh uses Zsh completion; no framework-specific adapter is needed.
- Shell initialization and key bindings remain user-controlled.
- The CLI handler owns CLI-specific definitions.
- Zsh's Bash-completion bridge supports the CLI's executable completion protocol without requiring Bash.

## Alternatives

### Oh My Zsh-Specific Completion

- Rejected: requires Oh My Zsh or a separate standalone-Zsh integration.

### External Completion Framework

- Rejected: Zsh provides the required extension points.

### Direct CLI Completion Protocol

- Invoke the CLI with adapted `COMP_LINE` and `COMP_POINT`; pass output lines to `compadd`.
- Avoids a registered CLI handler but requires VE to handle serialization, quoting and cursor offsets.
- Not preferred: Zsh's registered handler already provides this bridge.

## Consequences

- positive: One completion function serves standalone Zsh and Oh My Zsh.
- positive: CLI definitions remain in the delegated handler.
- negative: Registration depends on completion initialization and load order.
- negative: Delegation inherits the handler's capabilities and server access.
- positive: Installation enables the selected CLI's completion without a separate setup command.
- negative: The local check does not verify full interactive dispatch, quoting or cursor positions. Interactive tests are not a prerequisite; the test-complexity constraint applies.
- negative: VE must be sourced after completion initialization. Without `compdef`, registration is skipped; sourcing VE again registers completion.

## Assumptions

- Completion is initialized by the user or Oh My Zsh.

## Open Questions

- None

## References

- [VE-001: Profile URL Wrapper](../requirements/ve-001-profile-url-wrapper.md)
- [VE-002: Tab Completion](../requirements/ve-002-tab-completion.md)
- [VE-ADR-001: Small Zsh Wrapper](ve-adr-001-initial-implementation-as-zsh-plugin.md)
- [Vault autocomplete](https://developer.hashicorp.com/vault/docs/commands#enable-autocomplete)
- [OpenBao autocomplete](https://openbao.org/docs/commands/#autocompletion)
- [Oh My Zsh Vault plugin](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/vault/vault.plugin.zsh)
- [Zsh Bash-completion bridge](https://github.com/zsh-users/zsh/blob/master/Completion/bashcompinit)
- [CLI completion Zsh installer](https://github.com/posener/complete/blob/v1.2.3/cmd/install/zsh.go)
