# Utilities used within bashrc.c
#
# These are generally useful as well, and they remain available in the active session.
# Remember to copy them into any scripts that may need to run outside of the bashrc.d
# environment.

requires 'coreutils' 'realpath'

# Colored logging
function debug() { echo -e "\e[32mDEBUG  \e[39m ${*}"; }
function warn() { echo -e "\e[33mWARNING\e[39m ${*}"; }
function error() { echo -e "\e[31mmERROR \e[39m ${*}"; }
function nln() { echo ""; }
function dbg() {
  [[ -n "${BASHRC_DEBUG}" ]] && debug "$@"
}

function is_installed() {
  command -v "$1" >/dev/null 2>&1
  return $?
}

function is_file() {
  test -f "$1"
  return $?
}

function is_dir() {
  test -d "$1"
  return $?
}

# Add a directory path to the front of PATH, or another ":" delimited env var.
# - Converts relative path to absolute.
# - No-op if the path does not exist. Uses current dir if path not given.
# - Optional second argument allows acting on another env var.
function padd() {
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
is_mounted() { findmnt -rno SOURCE,TARGET "$1" >/dev/null; }

# Print argument split to lines. Default to $PATH if no argument is provided.
function path() {
  echo -n "${1:-:${PATH}}" |
    sed -re 's/:+/\n/g'
}

# Sort and remove any duplicates. Default to $PATH if no argument is provided.
#function dedup() { echo "${1:-:${PATH}}" | sort --unique --field-separator ":"; }
function dedup() {
  echo -n "${1:-:${PATH}}" | sed -re 's/[:\n]+/\n/g' |
    sort --unique --ignore-leading-blanks | tr '\n' ':'
}

# Return the current date-time in a format similar to ISO 8601.
# - Date and time are separated by a space instead of "T".
# - Hour, minute and second are separated by ";" instead of ":" (for use in filename)
function now() {
  printf "%s" "$(date "+%Y-%m-%d_%H;%M;%S")"
}

# Return the current date-time in a format similar to ISO 8601, for use in filenames.
# - Date and time are separated by an underscore instead of "T".
# - Hour, minute and second are separated by ";" instead of ":"
function nowfn() {
  printf "%s" "$(date "+%Y-%m-%d_%H;%M;%S")"
}

# Returns the absolute path to the directory of the caller.
function here() {
  echo -n "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}
