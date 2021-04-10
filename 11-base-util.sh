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
  # Bash syntax:
  # \033 is the escape character in octal, 27 decimal, 0x1b hex.
  printf "\033[01;%sm%s\033[00m\n" "${colors[${1}]}" "${2}"
}

################
err_hiliter() {
  bash | perl -pe 's/\w/\033[01;31m\1\033[00m/gi; last unless defined $_;'

  #  rx_list='exception|err(or|\W)'
  #  line = $_
  #  while true; do
  #    for r in rx_list; do
  #        [[ ]]
  #    done
  #  done
}

# Logging with colors
# - Bash syntax: The variable name for the array of arguments passed to a function is "".
# Imagine it as being in front of each starting square bracket:
# ${[@]} == (x=${@}; ${x[@]}).

__p() {
  # Print right adjusted. The ANSI color codes must be included in the count.
  printf "%20s " "$(color "$1" "$2")"
  shift 2
  while (( "$#" )); do
    str="$1"
    shift
    # Replace the special string "sep" with a repeating string that fills the rest of the line.
    if [[ "$str" == "sep" ]]; then
        # If 'sep' is not the last arg, use the next arg as the string to repeat.
      if (( "$#" )); then
        sep_str="$1"
        shift
      else
        sep_str="~"
      fi
      str="$(sep "$sep_str")"
    fi
    printf '%s' "$str"
    (( "$#" )) && printf ' '
  done
  printf '\n'
}

#__p() {
#  # TODO: Use 'shift' to simplify this.
#  # Print right adjusted. The ANSI color codes must be included in the count.
#  printf "%20s " "$(color "${1}" "${2}")"
#  # We pass the format string to printf in a variable.
#  # shellcheck disable=SC2059
#  local i=1;
#  local arg_count=$((${#} - 2))
#  for str in "${@:3}"; do
#    # Replace the special string "sep" with a repeating string that fills the rest of the line.
#    if [[ "$str" == "sep" ]]; then
#      # If 'sep' is not the last arg, use the next arg as the string to repeat.
#      if [[ $i < "$arg_count" ]]; then
#        sep_str="${*:$((i + 3)):1}"
#      else
#        sep_str="~"
#      fi
#      str="$(sep "$sep_str")"
#    fi
#    printf '%s' "$str"
#    (( i < arg_count)) && printf ' '
#    i=$((i + 1))
#  done
#  printf $'\n'
#}
#
# Print a line with severity level. The severity level is colorized when writing to a
# tty. Multiple arguments are printed on the same line separarated by a single space.
# The special string "sep" causes the remaining part of the line to be filled with a
# repeated character. The character is "~" by default. Another character can be selected
# by adding it after "sep". E.g. `pdebug "my message" sep =`  ,
#    DEBUG my message ===========================================
pdebug() { __p 'magenta' 'DEBUG' "${@}"; }
# Not named 'info' as that name is used by the GNU Info doc reader, often used for man pages.
pinfo() { __p 'green' 'INFO' "${@}"; }
pwarn() { __p 'yellow' 'WARNING' "${@}"; }
perror() { __p 'red' 'ERROR' "${@}"; }
pln() { printf "\n"; }

# Create a line of repeated strings that, when printed, will span from the current
# position of the caret to the end of the line. If space is wanted between the last
# last printed character and the start of the line, print the space before calling this
# method.
sep() {
  arg=("$@")
  req=()
  opt=('character or string to repeat')
  usage arg req opt && return 1
  local cur_col="$(get_caret_col)"
  local sep_str="${arg-~}"
  local sep_len="${#sep_str}"
  local fill_len=$((COLUMNS - cur_col))
  local full_count=$((fill_len / sep_len))
  local rem_count=$((fill_len - (full_count * sep_len)))
  for (( i = 0; i < full_count; i++ )); do
    printf '%s' "$sep_str"
  done
  printf '%s' "${sep_str::$rem_count}"
}

# Debugging for bashrc.d itself.
dbg() {
  (( BASHRC_DEBUG )) && pdebug "${@}"
}

# Return true if the script is sourced (invoked with "source <script>" or ". <script>".
is_sourced() {
  [[ "$0" == "${BASH_SOURCE[0]}" ]] || return 1;
  return 0;
}

cmd_is_installed() {
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

exists() {
  (is_file "$1" || is_dir "$1") && return 0
  return 1
}

is_in_list() {
  [[ "${!env_var}" =~ (^|"$sep")"$str"($|"$sep") ]] && return 0
  return 1
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
# - Date and time are separated by an underscore (_) instead of "T".
# - Hour, minute and second are separated by ";" instead of ":".
# - Note: ":" is valid for filenames under Linux, but it's invalid under Windows, and is
# used as a path separator on Unix, so it's best to avoid it.
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
# TODO: Check again. Doesn't work?
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
#  __args=('env var name (without dollar sign)' 'string to add' 'separator')
#  usage __in __args || return 1

  #  echo 1
  #	[[ "$#" -ne 4 ]] && {
  #	  echo 3
  #		# shellcheck disable=SC2016
  #		echo "Usage: $0 <env var name (without dollar sign)> <string to add> <delimiter>"
  #		return 1
  #	}
  #  echo 2

  #	[[ -n "$env_var" ]] || return

  local env_var="$1"
  local str="$2"
  local sep="$3"

  # dbg "env_var='%s'='%s', str='%s', sep='%s'\n" "$env_var" "${!env_var}" "$str" "$sep"

  if [[ ! -n "$env_var" ]]; then
    dbg "Skipped adding to \$$env_var: Empty string"
    return 0
  fi

  if is_in_list "$sep"; then
    dbg "Skipped adding \"$str\" to \$$env_var: Already in list: ${!env_var}"
    return 0
  fi

  # dbg "Adding \"$str\" to front of \$$env_var"
  # Bash syntax:
  # - `${param:+word}` equivalent in Python is `"word" if param else ""`. In
  # `${PATH:+:${PATH}}`, the first `:` is fixed syntax and the second is the list
  # separator for PATH. So the first `PATH` is the param and `:${PATH}` is the
  # section that will get expanded or set to "". Result is that, when starting with
  # an empty path, the list will not have a trailing ":". The syntax does not deal
  # with any other cases, like PATH already having leading or trailing ":".
  # - `${!var}` is indirect variable read.
  # - `printf -v var` is indirect variable write.
  printf -v "$env_var" "%s" "${str}${!env_var:+${sep}${!env_var}}"
  dbg "Added to \$$env_var: \"$str\""
  dbg "-> ${!env_var}"
  export "${env_var?}"
}

# Add double quotes to string if it contains spaces, else return it unchanged.
space_quote() {
  case $1 in
  *\ *) printf "\"%s\"" "$1" ;;
  *) printf "%s" "$1" ;;
  esac
}

usage() {
  # Passing multiple arrays to a function with the default pass-by-value causes them to
  # be combined to a single array. This declares the values as pass-by-reference, which
  # allows the arrays to be kept separate. The caller must not add "$" to the varaible
  # names (which currently caues IDEA based IDEs to complain about unused variables).
  declare -n arg_arr=$1
  declare -n req_arr=$2
  declare -n opt_arr=$3

  arg_count="${#arg_arr[@]}"
  req_count="${#req_arr[@]}"
  opt_count="${#opt_arr[@]}"

#  printf 'arg_count: %s\n' "$arg_count"
#  printf 'req_count: %s\n' "$req_count"
#  printf 'opt_count: %s\n' "$opt_count"

  (( arg_count >= req_count && arg_count <= (req_count + opt_count) )) && return 1;

  local arg_str="$([[ "$arg_arr" ]] && printf '"%s" ' "${arg_arr[@]}")"
  local req_str="$([[ "$req_arr" ]] && printf '[%s] ' "${req_arr[@]}")"
  local opt_str="$([[ "$opt_arr" ]] && printf '[%s (optional)] ' "${opt_arr[@]}")"

#  printf 'arg_str: %s\n' "$arg_str"
#  printf 'req_str: %s\n' "$req_str"
#  printf 'opt_str: %s\n' "$opt_str"

  printf 'Usage: %s %s %s\n' "${FUNCNAME[1]}" "$req_str" "$opt_str"
  printf 'Received: %s\n' "$arg_str"

  return 0
}

# Replace regular "alias" with one that includes logging.
alias() {
  arg=("$@"); req=('name=value'); opt=(); usage arg req opt && return 1
  # cmd_is_installed "$1" || return 0
  pinfo 'alias' "$@"
  command alias "$@"
}
