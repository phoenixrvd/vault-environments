# Load with: source /path/to/vault-environments.plugin.zsh
ve() {
  emulate -L zsh
  local directory=${VE_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/vault-environments}
  local action=${1-} name file address cli variable
  if (( $# == 0 )); then
    print -ru2 -- 'Usage: ve <profile> [command] [arguments...] | ve create|list|show|remove|help'
    return 1
  fi
  shift

  case $action in
    list|help)
      if (( $# != 0 )); then
        print -ru2 -- "Usage: ve $action"
        return 1
      fi
      if [[ $action == help ]]; then
        print -r -- 'Usage: ve <profile> [command] [arguments...]'
        print -r -- '       ve create|show|remove <profile>; ve list; ve help'
      else
        for file in "$directory"/profiles/*(N.); do
          print -r -- "${file:t}"
        done
      fi
      return 0 ;;
    create|show|remove)
      if (( $# != 1 )); then
        print -ru2 -- "Usage: ve $action <profile>"
        return 1
      fi
      name=$1 ;;
    *) name=$action ;;
  esac

  if [[ -z $name || $name == *[^a-z0-9-]* ||
        $name == (create|list|show|remove|help) ]]; then
    print -ru2 -- "ve: Invalid profile name: $name"
    return 1
  fi
  file=$directory/profiles/$name
  case $action in
    create)
      if [[ -e $file || -L $file ]]; then
        print -ru2 -- "ve: Profile already exists: $name"
        return 1
      fi
      read -r 'address?Vault URL: ' || return 1
      [[ -n $address ]] || { print -ru2 -- 've: A URL is required.'; return 1; }
      command mkdir -p -- "$directory/profiles" || return 1
      (setopt noclobber; print -r -- "$address" > "$file")
      return $? ;;
    remove)
      command rm -f -- "$file"
      return $? ;;
  esac

  if [[ ! -f $file || ! -r $file ]]; then
    print -ru2 -- "ve: No readable profile: $name"
    return 1
  fi
  address=$(< "$file")
  if [[ -z $address || $address == *$'\n'* ]]; then
    print -ru2 -- "ve: Profile must contain one URL: $name"
    return 1
  fi
  if [[ $action == show ]]; then
    print -r -- "$address"
    return 0
  fi

  [[ -r $directory/config ]] && cli=$(< "$directory/config")
  if [[ $cli != (vault|bao) ]]; then
    print -ru2 -- "ve: Set $directory/config to vault or bao."
    return 1
  fi
  if (( ! ${+commands[$cli]} )); then
    print -ru2 -- "ve: $cli is not available in PATH."
    return 1
  fi
  variable=VAULT_ADDR
  [[ $cli == bao ]] && variable=BAO_ADDR
  (export "$variable=$address"; command "$cli" "$@")
}
