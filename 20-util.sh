# Utilities used within bashrc.c
#
# These are generally useful as well, and they remain available in the active session.
# Remember to copy them into any scripts that may need to run outside of the bashrc.d
# environment.

require 'coreutils' # realpath

# Colored logging
debug() { echo -e "\e[32mDEBUG  \e[39m ${*}"; }
warn() { echo -e "\e[33mWARNING\e[39m ${*}"; }
error() { echo -e "\e[31mERROR  \e[39m ${*}"; }
nln() { echo ""; }
dbg() {
  [[ -n "${BASHRC_DEBUG}" ]] && debug "$@"
}

is_installed() {
  command -v "$1" >/dev/null 2>&1
  return $?
}

is_file() {
  test -f "$1"
  return $?
}

is_dir() {
  test -d "$1"
  return $?
}

# Add path to the front of PATH, or another ":" delimited env var.
# - Converts relative path to absolute.
# - No-op if the path does not exist.
# - Uses current dir if path not given.
# - Optional second argument allows acting on another env var.
padd() {
  path="$1"
  if [[ -n "$2" ]]; then env_var="$2"; else env_var="PATH"; fi
  abs_path="$(realpath --canonicalize-existing --quiet "$path")"
  if [ $? -eq 0 ]; then
    add_str "$path" ':' "$env_var"
  else
    dbg "Ignored non-existing path: $path"
  fi
}

# Add string to the front of a delimited list in an env var.
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

# Return true if the script is sourced (invoked with "source <script>" or ". <script>".
is_sourced() {
  [[ "$0" == "${BASH_SOURCE[0]}" ]] && return 0 || return 1
}

# Exit the script with warning if it was not sourced. Also turn off any executable
# permissions on the script file.
assert_is_sourced() {
  is_sourced || {
    echo "This script must be sourced: . $0"
    chmod a-x "$0"
    # `exit` in a sourced script causes the user's shell to be closed, but we can safely
    # use it here since we now know we are not sourced.
    exit
  }
}

# str or device
is_mounted() { findmnt -rno src,TARGET "$1" >/dev/null; }

# Print argument split to lines. Default to $PATH if no argument is provided.
path() {
  echo -n "${1:-:${PATH}}" |
    sed -re 's/:+/\n/g'
}

# Sort and remove any duplicates. Default to $PATH if no argument is provided.
#dedup() { echo "${1:-:${PATH}}" | sort --unique --field-separator ":"; }
dedup() {
  echo -n "${1:-:${PATH}}" | sed -re 's/[:\n]+/\n/g' |
    sort --unique --ignore-leading-blanks | tr '\n' ':'
}

# Return the current date-time in a format similar to ISO 8601.
# - Date and time are separated by a space instead of "T".
# - Hour, minute and second are separated by ";" instead of ":" (for use in filename)
# `
now() {
  printf "%s" "$(date "+%Y-%m-%d_%H;%M;%S")"
}

# Return the current date-time in a format similar to ISO 8601, for use in filenames.
# - Date and time are separated by an underscore instead of "T".
# - Hour, minute and second are separated by ";" instead of ":"
nowfn() {
  printf "%s" "$(date "+%Y-%m-%d_%H;%M;%S")"
}

# Returns the absolute path to the directory of the caller.
# - Works only from executed script, NOT from sourced script or interactive shell.
# - The solution at https://stackoverflow.com/a/246128/442006 works only if current dir
#   is the same as the script that defines the function. For it work in any dir, the
#   function must be copied into the calling script.
# - This solution, from https://gist.github.com/tvlooy/cbfbdb111a4ebad8b93e, works wherever
#   it is called from. The location of the script holding function is not relevant.
here() {
  echo -n "$(dirname $(readlink -f $0))"
}
