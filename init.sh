#!/usr/bin/env bash

# init.sh can be sourced or executed.
# If sourced, the sourcing script must set BASHRC_DIR.

#set -x

export BASHRC_DEBUG=0

[[ "$0" == "$BASH_SOURCE" ]] && ret='exit' || ret='return'

# Skip configuration if not running interactively.
[[ $- == *i* ]] || $ret

# Display 'last' info for login shells
shopt -q login_shell && {
  perl -pe 's/(\d\d)T(\d\d)/$1 $2/g; s/:00 / /g; s/wtmp.*\n//g;' \
    <(last --hostlast --dns --time-format iso --present now --fullnames -3 | tac)
}

[[ -n "$BASHRC_DIR" ]] || {
  BASHRC_DIR="$(dirname "$0")"
}

for sh in "$BASHRC_DIR"/*.sh; do
  [[ "$(basename "$sh")" != "init.sh" ]] && {
    [[ "$(basename "$sh")" =~ ^[0-9][0-9]- ]] && {
      # shellcheck disable=SC1090
      source "$sh"
      # [[ $BASHRC_DEBUG = "0" ]]
      # printf "\rbashrc.d - $sh"
      #    tput ed
      # A gotcha with this if/or/else pattern is that, if the script being sourced
      # ends with a command that returns a non-zero exit code, it will also run the
      # else part. To avoid that, we force the exit code to zero with 'true' here.
      true
    } || {
      echo >&2 "Ignored file not starting with \"\d\d-\": \"$sh\""
    }
  }
done

printf "\r"
tput ed
