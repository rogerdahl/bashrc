#!/usr/bin/env bash

# This script must be sourced: . init.sh

#set -x

# True: Any non-empty string
export BASHRC_DEBUG="y"

[[ "$0" == "${BASH_SOURCE[0]}" ]] && {
  echo "This script must be sourced: . $0"
  chmod a-x "$0"
  exit
}

# Skip configuration if not running interactively.
[[ $- == *i* ]] || return

echo 'bashrc.d...'

# Display 'last' info for login shells
shopt -q login_shell && {
  perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
    <(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
}

[[ -n "$BASHRC_DIR" ]] || {
  BASHRC_DIR="$(dirname "$0")"
}

for sh in "$BASHRC_DIR"/*.sh; do
  [[ -n "$BASHRC_DEBUG" ]] && echo "$sh"
  [[ ! "$(basename "$sh")" =~ ^[0-9][0-9]-.* ]] && {
    [[ -n "$BASHRC_DEBUG" ]] && echo 'ignored'
    continue
  }
  # shellcheck disable=SC1090
  source "$sh"
done
