#!/usr/bin/env zsh
set -eu

project=${0:A:h:h}
temporary=$(mktemp -d)
trap 'rm -rf -- "$temporary"' EXIT

# Keep all test files and shell configuration in a disposable home.
export HOME=$temporary TMPDIR=$temporary
unset XDG_CONFIG_HOME XDG_DATA_HOME ZDOTDIR VE_CONFIG_HOME
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"

# Both CLI stand-ins print the address, arguments and stdin they receive.
cat > "$HOME/bin/vault" <<'CLI'
#!/bin/sh
case "${0##*/}" in
  vault) printf '%s\n' "$VAULT_ADDR" ;;
  bao) printf '%s\n' "$BAO_ADDR" ;;
esac
printf '<%s>\n' "$@"
cat
exit "${TEST_EXIT:-0}"
CLI
chmod +x "$HOME/bin/vault"
cp "$HOME/bin/vault" "$HOME/bin/bao"

source "$project/vault-environments.plugin.zsh"
configuration=$HOME/.config/vault-environments
installation=$HOME/.local/share/vault-environments

# Profile creation, inspection, rejection and removal.
ve create dev <<< 'https://dev.example'
[[ $(ve list) == dev ]]
[[ $(ve show dev) == https://dev.example ]]
if ve create dev <<< 'https://other.example'; then exit 1; fi
[[ $(ve show dev) == https://dev.example ]]
if ve missing status; then exit 1; fi
if ve ../dev status; then exit 1; fi

# Completion registration and profile candidates, without an interactive shell.
(
  autoload -Uz compinit; compinit -D
  source "$project/vault-environments.plugin.zsh"
  [[ $_comps[ve] == _ve ]]
  compadd() { shift; print -rl -- "$@"; }
  CURRENT=2 words=(ve '')
  [[ $(_ve) == $'create\nlist\nshow\nremove\nhelp\ndev' ]]
  CURRENT=3 words=(ve show '')
  [[ $(_ve) == dev ]]
)

# Both CLIs receive the profile URL and unchanged arguments and input.
export VAULT_ADDR=old-vault BAO_ADDR=old-bao
for cli in vault bao; do
  print -r -- "$cli" > "$configuration/config"
  actual=$(print -r -- payload | ve dev kv get 'two words' '' '*')
  [[ $actual == $'https://dev.example\n<kv>\n<get>\n<two words>\n<>\n<*>\npayload' ]]
  [[ $VAULT_ADDR == old-vault && $BAO_ADDR == old-bao ]]
  code=0
  TEST_EXIT=7 ve dev status </dev/null >/dev/null || code=$?
  [[ $code == 7 ]]
done

# Reinstallation keeps one setup block; uninstall keeps profiles and config.
print -r -- '# keep' > "$HOME/.zshrc"
zsh "$project/install.zsh"
zsh "$project/install.zsh"
[[ $(grep -c ' # vault-environments$' "$HOME/.zshrc") == 3 ]]
cmp "$project/vault-environments.plugin.zsh" "$installation/vault-environments.plugin.zsh"
unfunction ve
source "$HOME/.zshrc"
[[ $_comps[ve] == _ve && $_comps[vault] == *'-C vault'* ]]
[[ $(ve dev status </dev/null) == $'https://dev.example\n<status>' ]]
mv "$HOME/bin/vault" "$HOME/vault"
zsh "$project/install.zsh"
source "$HOME/.zshrc"
[[ $_comps[bao] == *'-C bao'* ]]
zsh "$installation/uninstall.zsh"
[[ $(< "$HOME/.zshrc") == '# keep' ]]
[[ ! -e $installation/vault-environments.plugin.zsh && ! -e $installation/uninstall.zsh ]]
[[ -f $configuration/config && -f $configuration/profiles/dev ]]
ve remove dev
[[ ! -e $configuration/profiles/dev ]]

print -r -- 'Smoke tests passed.'
