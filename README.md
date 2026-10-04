# Vault Environments

[Deutsch](README.de.md)

Run Vault or OpenBao commands against named server profiles.

## Install

Requires Zsh, curl and Vault or OpenBao on Ubuntu.

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/install.zsh | zsh
```

Restart Zsh. Run again to update.

## Use

```zsh
ve create dev                       # asks for the URL
ve dev login -method=userpass username=alice
ve dev kv get secret/my-app
ve list
ve show dev
ve remove dev
```

Tab completes profiles, management commands and CLI arguments. Completion is enabled during installation.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/uninstall.zsh | zsh
```

Keeps profiles and configuration. Restart Zsh.

[Configuration and development](docs/development.md) · [Requirements](docs/requirements/ve-001-profile-url-wrapper.md)
