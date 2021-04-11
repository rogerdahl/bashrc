# The coreutils package "contains the basic file, shell and text manipulation utilities
# which are expected to exist on every operating system."
#
# These are generally useful as well, and they remain available in the interactive
# shell.

require 'coreutils' # realpath

# Exit the script with warning if it was not sourced. Also turn off any executable
# permissions on the script file.
assert_is_sourced() {
  is_sourced || {
    error "This script must be sourced: . $0"
    chmod a-x "$0"
    # `exit` in a sourced script causes the user's interactive shell to be closed, but
    # we can safely use it here since we now know we are not sourced.
    exit
  }
}

# Add path to the front of PATH, or another ":" delimited env var.
# - Converts relative path to absolute.
# - No-op if the path does not exist.
# - Uses current dir if path not given.
# - Optional second argument allows acting on another env var.
# - This is a wrapper for add_str(). See that command for adding to other types of
# lists.
padd() {
  # Bash syntax:
  # The array "@", which holds all the params passed to a function, holds the path
  # to the binary that is being executed as element 0. Confusingly, when referencing
  # the array as "${@}", only elements starting from 1 are included. When referencing
  # it as "${@:0:}", all elements are included.
  # echo "${@}" # -> 1 2 3 4 5
  # echo "${@:0}" -> /bin/bash 1 2 3 4 5
  arg=("$@") req=('string to add') opt=('env var name (without dollar sign)' 'separator')
  usage arg req opt && return 1

  path="$1"
  env_var="$2"
  sep_str="$3"

  # dbg "path=%s\n" "$path"
  # dbg "sep_str=%s\n" "$sep_str"
  # dbg "env_var=%s\n" "$env_var"

  [[ -z "$env_var" ]] && env_var='PATH'
  [[ -z "$sep_str" ]] && sep_str=':'

  # realpath is in coreutils.
  abs_path="$(realpath --canonicalize-existing --quiet "$path")"
  if [ $? -ne 0 ]; then
    dbg "Skipped adding non-existing path: $path"
    return 0;
  fi

  add_str "$env_var" "$abs_path" "$sep_str"
}

# https://unix.stackexchange.com/a/401978/21709
prepath() {
  local usage="\
Usage: prepath [-f] [-n] [-q] DIR
  -f Force dir to front of path even if already in path
  -n Nonexistent dirs do not return error status
  -q Quiet mode"

  local tofront=false errcode=1 qecho=echo
  while true; do case "$1" in
    -f)
      tofront=true
      shift
      ;;
    -n)
      errcode=0
      shift
      ;;
    -q)
      qecho=':'
      shift
      ;;
    *) break ;;
    esac done
  # Bad params always produce message and error code
  [[ -z $1 ]] && {
    echo 1>&2 "$usage"
    return 1
  }

  [[ -d $1 ]] || {
    $qecho 1>&2 "$1 is not a directory."
    return $errcode
  }
  dir="$(
    command cd "$1"
    pwd -P
  )"
  if [[ :$PATH: =~ :$dir: ]]; then
    $tofront || {
      $qecho 1>&2 "$dir already in path."
      return 0
    }
    PATH="${PATH#$dir:}"     # remove if at start
    PATH="${PATH%:$dir}"     # remove if at end
    PATH="${PATH//:$dir:/:}" # remove if in middle
  fi
  PATH="$dir:$PATH"
}
