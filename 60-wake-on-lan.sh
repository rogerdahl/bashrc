#!/usr/bin/env bash

# Bash syntax:
# -A: Associative array
# brackets: Subscript, required when declaring an associative array
declare -A MAC_MAP=(
  [r2]="60:45:CB:9C:4F:61"
  [r3]="b8:ee:65:4c:46:27"
)

wake() {
  host="$1"
  mac="${MAC_MAP[$host]}"
  printf "Waking up: %s\n" "$mac"
  sudo etherwake -Di enp38s0 "$mac"
}

