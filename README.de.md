# Vault Environments

[English](README.md)

Vault- oder OpenBao-Befehle mit benannten Serverprofilen ausführen.

## Installation

Benötigt Zsh, curl und Vault oder OpenBao unter Ubuntu.

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/install.zsh | zsh
```

Zsh neu starten. Zum Aktualisieren erneut ausführen.

## Verwendung

```zsh
ve create dev                       # fragt die URL ab
ve dev login -method=userpass username=alice
ve dev kv get secret/my-app
ve list
ve show dev
ve remove dev
```

Tab vervollständigt Profile, Verwaltungsbefehle und CLI-Argumente. Die Installation aktiviert die Completion.

## Deinstallation

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/uninstall.zsh | zsh
```

Profile und Konfiguration bleiben erhalten. Zsh neu starten.

[Konfiguration und Entwicklung](docs/development.md) · [Anforderungen](docs/requirements/ve-001-profile-url-wrapper.md)
