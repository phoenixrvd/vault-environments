# Vault Environments

[Deutsch](README.de.md)

`ve <profile> [command] [arguments...]` sets the profile's server URL and forwards the command to `vault` or `bao`. Authentication and other CLI behavior stay native.

## Install

Requires Zsh, curl and Vault or OpenBao on Ubuntu.

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/install.zsh | zsh
```

Selects the installed CLI (`vault` if both exist); stops if neither exists. Installs to `~/.local/share/vault-environments` and adds one source line to `.zshrc`. Start a new Zsh. Run again to update.

## Use

```zsh
ve create dev                       # asks for the URL
ve dev login -method=userpass username=alice
ve dev kv get secret/my-app
ve list
ve show dev
ve remove dev
```

Profiles are URL-only files in `~/.config/vault-environments/profiles/`; `config` contains `vault` or `bao`. The profile replaces inherited address variables for the CLI process; explicit `-address` flags still work.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/uninstall.zsh | zsh
```

Removes installed scripts and the source line; keeps configuration and profiles. Start a new Zsh.

[Configuration and development](docs/development.md) · [Requirements](docs/requirements/ve-001-profile-url-wrapper.md)
