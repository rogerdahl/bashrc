#!/usr/bin/env bash

# This script must be sourced: . init.sh

# As the numbered scripts have not been sourced yet, we keep this script minimal and
# self-contained.

# Silently skip configuration if not running interactively.
[[ $- == *i* ]] || return

here_sourced() {
  echo -n "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
}

# Skip with error if not sourced.
[[ "$0" != "${BASH_SOURCE[0]}" ]] || {
  echo >&2 "This script must be sourced: . $0"
  chmod a-x "$0"
  exit
}

echo 'bashrc.d...'

# Implicitly export everything.
#set -a

# Print source lines as they are executed.
#set -x

# This dir should be used by bashrc.d scripts when building internal paths.
BASHRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#echo "\$BASHRC_DIR=$BASHRC_DIR"

dbg() {
  [[ -n "${BASHRC_DEBUG}" ]] && echo "$@"
}

for sh in "$BASHRC_DIR"/*.sh; do
  dbg "$sh"
  [[ ! "$(basename "$sh")" =~ ^[0-9][0-9]-.* ]] && {
    [[ -n "$BASHRC_DEBUG" ]] && dbg 'ignored'
    continue
  }
  # shellcheck disable=SC1090
  source "$sh"
done

# Display 'last' info for login shells
shopt -q login_shell && {
  perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
    <(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
}

