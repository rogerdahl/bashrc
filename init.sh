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

echo 'bashrc.d...'

# This dir should be used by bashrc.d scripts when building internal paths.
BASHRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. "$BASHRC_DIR/util.sh"
dbg "\$BASHRC_DIR=$BASHRC_DIR"

for sh in "$BASHRC_DIR"/+([0-9][0-9]-*.sh); do
	dbg "$sh"
	# shellcheck disable=SC1090
	source "$sh"
done

# Display 'last' info for login shells
shopt -q login_shell && {
	perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
		<(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
}

dbg_sep

# ShellCheck complains about the variable being unused here, and says to export it.
# But it's already exported, and variables only need to be exported once, not every
# time they change.
# shellcheck disable=SC2034
#BASHRC_DEBUG=false

# Suppress any non-zero error code here to prevent it from showing up as an error in
# the first bash prompt that is rendered in the new shell.
true
