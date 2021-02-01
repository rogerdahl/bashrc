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
padd() {
  path="$1"
  if [[ -n "$2" ]]; then env_var="$2"; else env_var="PATH"; fi
  # realpath is in coreutils.
  abs_path="$(realpath --canonicalize-existing --quiet "$path")"
  if [ $? -eq 0 ]; then
    add_str "$path" ':' "$env_var"
  else
    dbg "Ignored non-existing path: $path"
  fi
}

# Add string to the front of a delimited list in an env var.
# To use for argument lists, pass a single space, " ", as the delimiter.
# The env var is created if it doesn't already exist.
# TODO: Option for ignoring duplicate entry
# TODO: Call this from padd.
add_str() {
  [[ "$#" -ne 4 ]] || {
    # shellcheck disable=SC2016
    echo "Usage: $0 <string to add> <delimiter> <env var name (no \$)>"
    return 1
  }
  str="$1"
  delimiter="$2"
  env_var="$3"
  dbg "Adding \"$str\" to front of \$$env_var"
  # Bash syntax:
  # - `${param:+word}` equivalent in Python is `"word" if param else ""`. In
  # `${PATH:+:${PATH}}`, the first `:` is fixed syntax and the second is the list
  # delimiter for PATH. So the first `PATH` is the param and `:${PATH}` is the section
  # that will get expanded or set to "". Result is that, when starting with an empty
  # path, the list will not have a trailing ":". The syntax does not deal with any other
  # cases, like PATH already having leading or trailing ":".
  # - `${!var}` is indirect variable read.
  # - `printf -v var` is indirect variable write.
  printf -v "$env_var" "%s" "${str}${!env_var:+${delimiter}${!env_var}}"
  dbg "Added to \$$env_var: $abs_path"
  dbg "-> ${!env_var}"
  export "${env_var?}"
}
