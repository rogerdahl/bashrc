#!/usr/bin/env bash

# This script must be sourced: . init.sh

# Silently skip configuration if not running interactively.
[[ $- == *i* ]] || return

# Implicitly export everything.
set -a

# Print source lines as they are executed.
#set -x

# BASHRC_DEBUG is set in 01-settings.py.

assert_is_sourced


echo 'bashrc.d...'


[[ -n "$BASHRC_DIR" ]] || {
  BASHRC_DIR="$(dirname "$0")"
}

for sh in "$BASHRC_DIR"/*.sh; do
  debug "$sh"
  [[ ! "$(basename "$sh")" =~ ^[0-9][0-9]-.* ]] && {
    [[ -n "$BASHRC_DEBUG" ]] && debug 'ignored'
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

