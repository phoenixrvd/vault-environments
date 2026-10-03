#!/usr/bin/env zsh

emulate -LR zsh

if (( $# != 0 )); then
  print -ru2 -- 'Usage: zsh install.zsh'
  exit 1
fi

if (( ${+commands[vault]} )); then
  cli=vault
elif (( ${+commands[bao]} )); then
  cli=bao
else
  print -ru2 -- \
    'VE requires Vault or OpenBao.' \
    'Install vault or bao first and make it available in PATH, then rerun the installer.'

  exit 1
fi

configuration=${VE_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/vault-environments}
installation=${XDG_DATA_HOME:-$HOME/.local/share}/vault-environments
startup=${ZDOTDIR:-$HOME}/.zshrc
plugin=$installation/vault-environments.plugin.zsh
source_directory=${0:A:h}

# When run through curl, fetch the two files before changing the installation.
if [[ ! -f $0 ]]; then
  source_directory=$(command mktemp -d) || exit 1
  trap 'command rm -rf -- "$source_directory"' EXIT

  for file in vault-environments.plugin.zsh uninstall.zsh; do
    command curl -fsSL \
      "https://raw.githubusercontent.com/phoenixrvd/vault-environments/main/$file" \
      -o "$source_directory/$file" || exit 1
  done
fi

command mkdir -p -- "$installation" "$configuration" "${startup:h}" || exit 1

command cp -- \
  "$source_directory/vault-environments.plugin.zsh" \
  "$source_directory/uninstall.zsh" \
  "$installation/" || exit 1

print -r -- "$cli" > "$configuration/config" || exit 1

command touch -- "$startup" || exit 1

command sed \
  -i --follow-symlinks \
  '/ # vault-environments$/d' \
  -- "$startup" || exit 1

[[ ! -s $startup || -z $(command tail -c 1 -- "$startup") ]] ||
  print >> "$startup"

print -r -- "source ${(q)plugin} # vault-environments" \
  >> "$startup" || exit 1

print -r -- \
  "VE installed ($cli)." \
  'Start a new Zsh.'
