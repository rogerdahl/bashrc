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

  # Contains a newline?
  # "${FUNCNAME[1]}"

  # Due to the default args, this command is not a got fit for the general usage()
  # function.

#  [[ -d "$path" ]] || {
#    stacktrace
#  }
#  return

#  printf "%s %s %s" "$path" "$delimiter" "$env_var"
#  printf '==========================================\n'

  [[ -n "$1" ]] || {
    printf '%s\n' 'Usage: padd <path> <optional delimiter> <optional var name>'
    printf '%s\n' 'If given only a path, adds it to PATH, using delimiter ":"'
    return 1
  }
  # Add default delimiter, ":"
  [[ -n "$2" ]] || {
    set -- "${@:1:1}" ":" "${@:3}"
  }
  # Add default env var, "PATH"
  [[ -n "$3" ]] || {
    set -- "${@:1:2}" "PATH" "${@:4}"
  }

  path="$1"
  delimiter="$2"
  env_var="$3"

  dbg 'path="%s", delimiter="%s", env_var="%s"\n' "$path" "$delimiter" "$env_var"

  # realpath is in coreutils.
  abs_path="$(realpath --canonicalize-existing --quiet "$path")"
  if [ $? -eq 0 ]; then
    add_str "$env_var" "$abs_path" "$delimiter"
  else
    dbg 'Ignored non-existing path: %s' "$path"
  fi
}
