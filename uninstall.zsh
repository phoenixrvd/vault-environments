#!/usr/bin/env zsh

emulate -LR zsh

zshrc_file=${ZDOTDIR:-$HOME}/.zshrc
installation=${XDG_DATA_HOME:-$HOME/.local/share}/vault-environments

# Remove the source line marked by the installer.
if [[ -e $zshrc_file ]]; then
  if ! command sed \
    -i --follow-symlinks \
    '/ # vault-environments$/d' \
    -- "$zshrc_file"; then

    print -ru2 -- "VE uninstall failed: could not update $zshrc_file"
    exit 1
  fi
fi

command rm -f -- \
  "$installation/vault-environments.plugin.zsh" \
  "$installation/uninstall.zsh" || exit 1

print -r -- \
  'VE uninstalled.' \
  'Profiles and configuration were kept.' \
  'Start a new Zsh.'
