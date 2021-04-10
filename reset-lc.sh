#!/usr/bin/env bash

[[ "$0" == "${BASH_SOURCE[0]}" ]] && {
  echo "This script must be sourced: . $0"
  chmod a-x "$0"
  exit
}

export LOCPATH="$(realpath "locale")"
export LANG="en_US.utf8"
