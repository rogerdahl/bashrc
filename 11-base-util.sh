# Basic utilities with no dependencies outside of bash
#
# A set of basic utilities that the rest of .bashrc.d can rely on being available. They
# are generally useful and available in the interactive shell as well.

# Return true if the script is sourced (invoked with "source <script>" or ". <script>".
is_sourced() {
  [[ "$0" != "${BASH_SOURCE[0]}" ]] && return 0 || return 1
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
  arg=("$@") req=('string to check') opt=('env var name (without dollar sign)' 'separator')
  usage arg req opt && return 1

  local env_var="$1"
  local value="$2"
  local sep_str="$3"

  [[ -z "$env_var" ]] && env_var='PATH'
  rx="(^|${sep_str})$value(\$|${sep_str})"
  [[ "${!env_var}" =~ $rx ]] && return 0
  return 1
}

# Print the search path
path() {
  declare -a path_arr
  IFS=":" read -r -d '' -a path_arr <<<"$PATH"
  printf 'Path, split by ":":\n'
  IFS=":" printf '  %s\n' ${path_arr[*]}
}

# Print delimited string as list, one entry per line
plist() {
  arg=("$@")
  req=('print command' 'string holding list delimited by separator')
  opt=('separator (default=":")')
  usage arg req opt && return 1

  cmd="$1"
  str="$2"
  sep_str="$3"

  # Add default delimiter, ":"
  [[ -z "$sep_str" ]] && sep_str=":"

  local IFS="$sep_str"
  #  for s in ${str[*]}; do
  IFS=":" printf '  %s\n' ${cmd[*]}
  #    $cmd " " "$s"
  #  done
}

# Split string to array.
# An array cannot be returned directly in bash. Instead, the caller creates an array and
# passes the NAME of the array. This method then fills the array in with the result.
split() {
  out_name="$1"
  in_str="$2"
  [[ -z $in_str ]] && in_str="PATH"
  sep_str="$3"
  [[ -z $sep_str ]] && sep_str=":"
  IFS="${sep_str}" read -r -d '' -a $out_name <<<"${in_str}"
}

# Print PATH, one line per entry
ppath() {
  declare -a ork
  split ork $PATH
  printf '$PATH:\n'
  printf '  %s\n' ${ork[*]}
}

# Sort and remove any duplicates. Default to $PATH if no argument is provided.
#dedup() { echo "${1:-:${PATH}}" | sort --unique --field-separator ":"; }
dedup() {
  echo -n "${1:-:${PATH}}" | sed -re 's/[:\n]+/\n/g' |
    sort --unique --ignore-leading-blanks | tr '\n' ':'
}

# Return the current date-time in a format similar to ISO 8601.
# - Date and time are separated by a space instead of "T".
# - Hour, minute and second are separated by "-" instead of ":".
# - This format is safe for filenames, and sorting alphabetically will also sort
#   chronologically.
now() {
  printf '%s' "$(date "+%Y-%m-%d_%H-%M-%S")"
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
#
# Bash syntax:
#
# - `${param:+word}` equivalent in Python is `"word" if param else ""`. In
# `${PATH:+:${PATH}}`, the first `:` is fixed syntax and the second is the list
# separator for PATH. So the first `PATH` is the param and `:${PATH}` is the
# section that will get expanded or set to "". Result is that, when starting with
# an empty path, the list will not have a trailing ":". The syntax does not deal
# with any other cases, like PATH already having leading or trailing ":".
# - `${!var}` is indirect variable read.
# - `printf -v var` is indirect variable write.
add_str() {
  arg=("$@") req=('env var name (without dollar sign)' 'string to add') opt=('separator')
  usage arg req opt && return 1

  env_var="$1"
  value="$2"
  sep_str="$3"

  [[ -z "$sep_str" ]] && sep_str=":"

  is_in_list "$env_var" "$value" "$sep_str" && {
    dbg "Skipped adding \"$value\" to \$$env_var: Already in list"
    plist 'dbg' "${!env_var}" "$sep_str"
    return 0
  }

  if [[ -z "$value" ]]; then
    dbg "Skipped adding to \$$env_var: Value is empty"
    return 0
  fi

  printf -v "$env_var" "%s" "${value}${!env_var:+${sep_str}${!env_var}}"
  dbg "Added \"$value\" to \$$env_var. New list:"
  plist 'dbg' "${!env_var}" "$sep_str"
}

# Add double quotes to string if it contains spaces, else return it unchanged.
quote_space() {
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
  #
  # 'declare' implicitly makes variables local.
  declare -n arg_arr=$1
  declare -n req_arr=$2
  declare -n opt_arr=$3

  arg_count="${#arg_arr[@]}"
  req_count="${#req_arr[@]}"
  opt_count="${#opt_arr[@]}"

  ((arg_count >= req_count && arg_count <= (req_count + opt_count))) && return 1

  local arg_str="$([[ "$arg_arr" ]] && printf '"%s" ' "${arg_arr[@]}")"
  local req_str="$([[ "$req_arr" ]] && printf '[%s] ' "${req_arr[@]}")"
  local opt_str="$([[ "$opt_arr" ]] && printf '[%s (optional)] ' "${opt_arr[@]}")"

  #  pdebug 'usage():'
  #  pdebug 'arg_str' "$arg_str" "(len=${arg_count})"
  #  pdebug 'req_str' "$req_str" "(len=${req_count})"
  #  pdebug 'opt_str' "$opt_str" "(len=${opt_count})"

  printf 'Usage: %s %s %s\n' "${FUNCNAME[1]}" "$req_str" "$opt_str"
  printf 'Received: %s\n' "$arg_str"

  return 0
}

# Replace regular "alias" with one that includes logging.

alias() {
  #  arg=("$@"); req=('name=value'); opt=(); usage arg req opt && return 1
  # TODO: Skip alias for non-existing command
  # cmd_is_installed "$1" || return 0
  dbg 'alias' "$@"
  command alias "$@"
}

select_file() {
  declare -n _files="$1"
  #  local files="$1"
  #  local files=("$1/"*)
  local PS3='Select file or 0 to cancel: '
  # Force `select` to print the options in a single column.
  local COLUMNS=1
  #  printf '\n'
  select file in "${_files[@]}"; do
    if [[ $REPLY == "0" ]]; then
      printf >&2 'Cancelled'
      return 1
    elif [[ -z $file ]]; then
      continue
    else
      #      printf >&2 'Selected: %s\n' "$file"
      printf '%s' "$file" | perl -pe 's/^\s*//; s/\s*$//' # trim
      return 0
    fi
  done
}

confirm() {
  while true; do
    read -r -p 'Ok? (y/n): ' reply
    [[ "${reply,,}" == 'y' ]] && return 0
    [[ "${reply,,}" == 'n' ]] && return 1
  done
}

# Join array to string, with single character separator
# Pass the array by reference (var, not $var)
join_arr() {
  local -n _arr="$1"
  local -n _sep="$2"
  # sep=
  # arr
  IFS="${_sep}"
  echo "${_arr[*]}"
}
