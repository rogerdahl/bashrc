# Basic utilities with no dependencies outside of bash
#
# A set of basic utilities that the rest of .bashrc.d can rely on being available. They
# are generally useful and available in the interactive shell as well.

# Wrap text in one of the 8 basic ANSI colors.
declare -A colors=([black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34 [magenta]=35 [cyan]=36 [white]=37)
color() {
  [[ $# -eq 2 ]] || {
    printf "Usage: color black/red/green/yellow/blue/magenta/cyan/white <text to print in color>\n"
    return 1
  }
  printf "\033[01;%sm%s\033[00m\n" "${colors[${1}]}" "${2}"
}

# Logging with colors
# - Bash syntax: The variable name for the array of arguments passed to a function is "".
# Imagine it as being in front of each starting square bracket:
# ${[@]} == (x=${@}; ${x[@]}).

__p() {
  # Print right adjusted. The ANSI color codes must be included in the count.
  printf "%20s " "$(color "${1}" "${2}")"
  # We pass the format string to printf in a variable.
  # shellcheck disable=SC2059
  printf "%s" "${@:3}" $'\n'
}
debug() { __p 'magenta' 'DEBUG' "${*}"; }
info() { __p 'green' 'INFO' "${*}"; }
warn() { __p 'yellow' 'WARNING' "${*}"; }
error() { __p 'red' 'ERROR' "${*}"; }
ln() { printf "\n"; }

# Draw a line to separate two sections of text
sep() {
  local cur_col="$1" || "0"
  local i=$((COLUMNS - cur_col))
  while ((i--)); do printf '~'; done
  echo
}

# Debugging for bashrc.d itself.
dbg() {
  (( BASHRC_DEBUG )) && debug "${*}"
}
dbg_sep() {
  debug "$(sep 8)"
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

# Get the absolute path to the directory of the caller.
# - Use from executed script, NOT from sourced script or interactive shell.
# - For sourced scripts, see `here_sourced`.
# - Notes:
# - Most solutions for this found online, such as the popular one at
#   https://stackoverflow.com/a/246128/442006, assume that the function and the caller are
#   in the same script, and break if the function is defined in another script.
# - This solution, from https://gist.github.com/tvlooy/cbfbdb111a4ebad8b93e, works wherever
#   it is called from. The location of the script holding function is not relevant.
here() {
  echo -n "$(dirname "$(readlink -f "$0")")"
  #  echo -n "$(dirname $(readlink -f $0))"
}

# Get the absolute path to the directory of the caller.
# - Use from sourced script or interactive shell, NOT from executed  script or
#   interactive shell.
# TODO: Check again. Doesn't work.
here_sourced() {
  echo -n "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
}

# Use the presence of a file to flag some condition.

is_flag() {
  [[ $# -eq 2 ]] || {
    echo "Usage: $0 <component> <flag name>"
    return 1
  }
  is_file "$BASHRC_DIR/$1/${2^^}" && {
    dbg "$1 is ${2,,}"
    return 0
  }
  return 1
}

set_flag() {
  [[ $# -eq 2 ]] || {
    echo "Usage: $0 <component> <flag name>"
    return 1
  }
  mkdir -p "$BASHRC_DIR/$1"
  touch "$BASHRC_DIR/$1/${2^^}"
}

clear_flag() {
  [[ $# -eq 2 ]] || {
    echo "Usage: $0 <component> <flag name>"
    return 1
  }
  [[ -n "$1" ]] || exit # Making sure we don't wipe out the root dir for now
  rm -f "$BASHRC_DIR/$1/${2^^}"
}

# Add string to the front of a delimited list in an env var.
# - This is a no-op if:
#   - String is blank or undefined (so this function is not suitable for use where blank
#   strings should be inserted, and would cause two consecutive delimiters)
#   - String is already in list
# - To use for argument lists, pass a single space, " ", as the delimiter. The env var
# is created if it doesn't already exist.
add_str() {
  [[ "$#" -ne 4 ]] || {
    # shellcheck disable=SC2016
    echo "Usage: $0 <string to add> <delimiter> <env var name (no \$)>"
    return 1
  }

  [[ -n "$env_var" ]] || return

  local env_var="$1"
  local str="$2"
  local del="$3"

  # dbg "env_var='%s'='%s', str='%s', del='%s'\n" "$env_var" "${!env_var}" "$str" "$del"

  if [[ -n "$env_var" ]]; then
    if [[ "${!env_var}" =~ (^|"$del")"$str"($|"$del") ]]; then
      dbg "Skipped adding to \$$env_var: Already in list: $str"
    else
      dbg "Adding \"$str\" to front of \$$env_var"
      # Bash syntax:
      # - `${param:+word}` equivalent in Python is `"word" if param else ""`. In
      # `${PATH:+:${PATH}}`, the first `:` is fixed syntax and the second is the list
      # del for PATH. So the first `PATH` is the param and `:${PATH}` is the section
      # that will get expanded or set to "". Result is that, when starting with an empty
      # path, the list will not have a trailing ":". The syntax does not deal with any other
      # cases, like PATH already having leading or trailing ":".
      # - `${!var}` is indirect variable read.
      # - `printf -v var` is indirect variable write.
      printf -v "$env_var" "%s" "${str}${!env_var:+${del}${!env_var}}"
      dbg "Added to \$$env_var: \"$str\""
      dbg "-> ${!env_var}"
      export "${env_var?}"
    fi
  else
    dbg "Skipped adding to \$$env_var: Empty string"
  fi
}

# Add double quotes to string if it contains spaces, else return it unchanged.
space_quote() {
  case $1 in
  *\ *) printf "\"%s\"" "$1" ;;
  *) printf "%s" "$1" ;;
  esac
}

# Print a "Usage' string and return 1 if number of arguments is outside of range.
# Usage of usage() (can it be made to look nicer?):
#     __in=( "$@" );
#     __args=('name of arg 1' 'name of arg 2' ...);
#  usage __in __args
usage() {
  # Bash syntax:
  # 'local -n' declares 'namevars' (new in Bash 4.3). They're call-by-reference.
  # Bizarrely, they cause name collisions between functions even though they're declared
  # with 'local'.
  local -n __arg_arr=$1
  local -n __name_arr=$2
  local __func_name="${FUNCNAME[1]}"
  dbg 'args:' "${__arg_arr[@]}"
  dbg 'names:' "${__name_arr[@]}"
  dbg 'len args:' ${#__arg_arr[@]}
  dbg 'len names:' "${#__name_arr[@]}"
  # IFS contains the token that strings are split to array with.
  # IFS='^'
  dbg 'len names:' "${__name_arr[*]}"
  ((${#__arg_arr[@]} < ${#__name_arr[@]})) && {
    printf "Usage: %s %s\n" "$__func_name" \
      "$(for arg in "${__name_arr[@]}"; do printf "%s" "<${arg}> "; done)"
    return 1
  }
  return 0
}
