#!/usr/bin/env bash

# Source from .bashrc with:
# . ${HOME}/bin/bashrc.d/init.sh

BASHRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export BASHRC_DIR

function init() {
  # Source all the 'bashrc.d' files
  for sh in "${BASHRC_DIR}"/*.sh; do
    test "$(basename "$sh")" != "$(basename "${BASH_SOURCE[0]}")" && {
      # echo "$sh"
      source "$sh"
    }
  done
}

# Skip configuration if not running interactively
case $- in
  *i*) init ;;
  *) ;;
esac
