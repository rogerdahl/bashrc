#!/usr/bin/env bash

# init.sh can be sourced or executed.
# If sourced, the sourcing script must set BASHRC_DIR.

#set -x

[[ "$0" == "$BASH_SOURCE" ]] && ret='exit' || ret='return'

# Skip configuration if not running interactively.
case $- in
*i*) ;;

*)
  echo >&2 'bashrc.d skipped: Shell is not interactive'
  $ret 0
  ;;
esac

test -n "$BASHRC_DIR" || {
  BASHRC_DIR="$(dirname "$0")"
}

#echo >&2 "BASHRC_DIR: $BASHRC_DIR"

#$ret 0

for sh in "$BASHRC_DIR"/*.sh; do
  test "$(basename "$sh")" != "init.sh" && {
    printf "\rbashrc.d - $sh"
    tput ed
    # shellcheck disable=SC1090
    source "$sh"
  }
done

printf "\r"
tput ed

perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
  <(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
