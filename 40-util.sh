# Utilities used within bashrc.c. These are generally useful as well, just remember to
# either copy them into the new scripts if they should run outside of an environment set
# up by bashrc.d.

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

# Add a directory path to $PATH.
# Converts relative path to absolute. No-op if the path does not exist. Uses current dir if path not given.
function padd() {
  p="$(realpath --canonicalize-existing --quiet "$1")"
  if [ $? -eq 0 ]; then
    export PATH="$p:$PATH"
    #echo "Added to PATH: $p"
  fi
}

# path or device
is_mounted() { findmnt -rno SOURCE,TARGET "$1" >/dev/null; }

# Print argument split to lines and sorted. Default to $PATH if no argument is provided.
function path() {
  echo -n "${1:-:${PATH}}" |
    sed -re 's/:+/\n/g' | sort --ignore-leading-blanks
}

# Add path if it references an existing dir. This is passed through "dedup" at the end
# of the script.
function padd() { is_dir "$1" && PATH="$1:$PATH"; }

# Sort and remove any duplicates. Default to $PATH if no argument is provided.
#function dedup() { echo "${1:-:${PATH}}" | sort --unique --field-separator ":"; }
function dedup() {
  echo -n "${1:-:${PATH}}" | sed -re 's/[:\n]+/\n/g' |
    sort --unique --ignore-leading-blanks | tr '\n' ':'
}

# Common utilities
case "${OSTYPE}" in
solaris*) OSNAME="SOLARIS" ;;
darwin*) OSNAME="MACOSX" ;;
linux*) OSNAME="LINUX" ;;
bsd*) OSNAME="BSD" ;;
msys*) OSNAME="WINDOWS" ;;
*) OSNAME="${OSTYPE}" ;;
esac

# Colored logging
function info() { echo -e "\e[32m*\e[39m ${*}"; }
function warn() { echo -e "\e[33m*\e[39m ${*}"; }
function error() { echo -e "\e[31m*\e[39m ${*}"; }
function nln() { echo ""; }

# Return the current date-time in a format similar to ISO 8601.
# - Date and time are separated by an underscore instead of "T".
# - Hour, minute and second are separated by ";" instead of ":" (for use in filename)
function iso-now() {
  printf "%s" "$(date "+%Y-%m-%d_%H;%M;%S")"
}
