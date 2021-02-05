#!/usr/bin/env bash

# This script must be sourced: . util.sh

# Source numbered scripts 10 - 19. These are general utilities intended for use both in
# interactive shell and scripts.

BASHRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

for sh in "$BASHRC_DIR"/+(1[0-9]-*.sh); do
	#  echo "$sh"
	. "$sh"
done
