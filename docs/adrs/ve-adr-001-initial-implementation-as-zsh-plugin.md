---
state: accepted
---

# VE-ADR-001: Small Zsh Wrapper

## Status

accepted

## Context

- Constraints: [Profile Storage](../requirements/ve-001-profile-url-wrapper.md#profile-storage), [Implementation Simplicity](../requirements/ve-001-profile-url-wrapper.md#implementation-simplicity).
- Behavioral boundaries: [Explicit Profile](../requirements/ve-001-profile-url-wrapper.md#explicit-profile), [CLI Delegation](../requirements/ve-001-profile-url-wrapper.md#cli-delegation).
- Lifecycle: [Shell Integration](../requirements/ve-001-profile-url-wrapper.md#shell-integration), [Download Installation](../requirements/ve-001-profile-url-wrapper.md#download-installation).

## Decision

- Implement a sourced Zsh function with shell file operations and subprocess CLI delegation.
- Keep installation and uninstallation in separate scripts; load the installed plugin, not the checkout.
- Prefer native Zsh features. Introduce a framework only if it substantially simplifies implementation; document that comparison in an ADR.

## Rationale

- Zsh provides file reads, non-overwriting writes and subprocess environment isolation.
- These operations need no framework in the current implementation.

## Alternatives

### Framework-Based Wrapper

- Not selected: native Zsh handles the current scope. Allowed if the simplification outweighs integration complexity.

## Consequences

- positive: No runtime dependency on the repository checkout.
- negative: `ve` requires the plugin to be sourced in Zsh.

## Assumptions

- None

## Open Questions

- None

## References

- [VE-001: Profile URL Wrapper](../requirements/ve-001-profile-url-wrapper.md)
- [VE-ADR-002: Native Zsh Completion](ve-adr-002-use-native-zsh-completion.md)
