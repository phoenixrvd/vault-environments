# Vault Environments

[English](README.md)

`ve <profil> [befehl] [argumente...]` setzt die Server-URL des Profils und reicht den Befehl an `vault` oder `bao` weiter. Authentifizierung und sonstiges CLI-Verhalten bleiben nativ.

## Installation

Benötigt Zsh, curl und Vault oder OpenBao unter Ubuntu.

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/install.zsh | zsh
```

Wählt die installierte CLI (`vault`, falls beide vorhanden sind); bricht ab, falls beide fehlen. Installiert nach `~/.local/share/vault-environments` und ergänzt eine Source-Zeile in `.zshrc`. Danach eine neue Zsh starten. Erneutes Ausführen aktualisiert die Installation.

## Verwendung

```zsh
ve create dev                       # fragt die URL ab
ve dev login -method=userpass username=alice
ve dev kv get secret/my-app
ve list
ve show dev
ve remove dev
```

Profile sind reine URL-Dateien in `~/.config/vault-environments/profiles/`; `config` enthält `vault` oder `bao`. Das Profil ersetzt geerbte Adressvariablen für den CLI-Prozess; explizite `-address`-Flags funktionieren weiterhin.

## Deinstallation

```sh
curl -fsSL https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/uninstall.zsh | zsh
```

Entfernt installierte Skripte und die Source-Zeile; behält Konfiguration und Profile. Danach eine neue Zsh starten.

[Konfiguration und Entwicklung](docs/development.md) · [Anforderungen](docs/requirements/ve-001-profile-url-wrapper.md)
