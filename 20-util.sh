# Utilities used within bashrc.c
#
# These are generally useful as well, and they remain available in the active session.
# Remember to copy them into any scripts that may need to run outside of the bashrc.d
# environment.

requires 'coreutils' 'realpath'

# Colored logging
debug() { echo -e "\e[32mDEBUG  \e[39m ${*}"; }
warn() { echo -e "\e[33mWARNING\e[39m ${*}"; }
error() { echo -e "\e[31mmERROR \e[39m ${*}"; }
nln() { echo ""; }
dbg() {
  [[ -n "${BASHRC_DEBUG}" ]] && debug "$@"
}

is-installed() {
  command -v "$1" >/dev/null 2>&1
  return $?
}

is-file() {
  test -f "$1"
  return $?
}

is-dir() {
  test -d "$1"
  return $?
}

# Add a directory path to the front of PATH, or another ":" delimited env var.
# - Converts relative path to absolute.
# - No-op if the path does not exist. Uses current dir if path not given.
# - Optional second argument allows acting on another env var.
padd() {
  dir_path="$1"
  if [[ -n "$2" ]]; then env_var="$2"; else env_var="PATH"; fi
  abs_path="$(realpath --canonicalize-existing --quiet "$dir_path")"
  if [ $? -eq 0 ]; then
    # Indirect variable read: ${!var}
    # Indirect variable update: printf -v var
    printf -v "$env_var" "%s" "$abs_path${!env_var:+:${!env_var}}"
    export "${env_var?}"
    dbg "Added to $env_var: $abs_path"
    dbg "New $env_var: ${!env_var}"
  else
    dbg "Ignored non-existing directory: $dir_path"
  fi
}

# path or device
is-mounted() { findmnt -rno src,TARGET "$1" >/dev/null; }

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
