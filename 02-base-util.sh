# Basic utilities with no dependencies outside of bash
#
# A set of basic utilities that the rest of .bashrc.d can rely on being available. They
# are generally useful and available in the interactive shell as well.

# Colored logging
debug() { echo -e "\e[32mDEBUG  \e[39m ${*}"; }
warn() { echo -e "\e[33mWARNING\e[39m ${*}"; }
error() { echo -e "\e[31mERROR  \e[39m ${*}"; }
nln() { echo ""; }

# Debugging for bashrc.d itself.
dbg() {
  [[ -n "${BASHRC_DEBUG}" ]] && debug "$@"
}

# Return true if the script is sourced (invoked with "source <script>" or ". <script>".
is_sourced() {
  [[ "$0" != "${BASH_SOURCE[0]}" ]] && return 0 || return 1
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
# - Works when invoked from another script.
# - Works wherever it is called from.
# - Works only from executed script, NOT from sourced script or interactive shell.
# - Notes:
# - Most solutions for this found online assume that the function and the caller are in
#   the same script, and break if the function is defined in another script.
# - The solution at https://stackoverflow.com/a/246128/442006 works only if current dir
#   is the same as the script that defines the function. For it work in any dir, the
#   function must be copied into the calling script.
# - This solution, from https://gist.github.com/tvlooy/cbfbdb111a4ebad8b93e, works wherever
#   it is called from. The location of the script holding function is not relevant.
here() {
  echo -n "$(dirname "$(readlink -f $0)")"
#  echo -n "$(dirname $(readlink -f $0))"
}

here_sourced() {
  echo -n "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
}

