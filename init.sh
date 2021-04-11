#!/usr/bin/env bash

# This script must be sourced: $ . init.sh

# As the numbered scripts have not been sourced yet, we keep this script minimal and
# self-contained.

# Silently skip configuration if not running interactively.
[[ $- == *i* ]] || return

# Skip with error if not sourced.
[[ "$0" != "${BASH_SOURCE[0]}" ]] || {
  echo >&2 "This script must be sourced: . $0"
  chmod a-x "$0"
  exit
}

printf 'bashrc.d...\n'

# This dir should be used by bashrc.d scripts when building internal paths.
BASHRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# We want to be able to drop any executable dependencies for any of the scripts into
# ./bashrc.d/bin without worrying about if that's in the path yet, so we add it here.
#PATH="$BASHRC_DIR/bin${PATH:+:${PATH}}"
#export PATH

# Source scripts 00 - 19. These are general utilities intended for use both in
# interactive shell and scripts.
. "$BASHRC_DIR/util.sh"
padd "$BASHRC_DIR/bin"

# Source scripts 20-99. These provide functionality intended for use in interactive
# shell.
for sh in "$BASHRC_DIR"/+([2-9][0-9]-*.sh); do
  dbg "$sh" sep
  # shellcheck disable=SC1090
  . "$sh"
done

# Display 'last' info for login shells
shopt -q login_shell && {
  perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
    <(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
}

dbg sep

# ShellCheck complains about the variable being unused here, and says to export it.
# But it's already exported, and variables only need to be exported once, not every
# time they change.
# shellcheck disable=SC2034
#BASHRC_DEBUG=false

# Suppress any non-zero error code here to prevent it from showing up as an error in
# the first bash prompt that is rendered in the new shell.
true
