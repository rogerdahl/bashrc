# Logging

# Simple logging that outputs a tag to indicate the severity of the message. If output
# is to the terminal, the tag is also wrapped with an ANSI color code. Tags are:
# DEBUG (magenta), INFO (green), WARNING (yellow), and ERROR (red).

# - Bash syntax: The variable name for the array of arguments passed to a function is "".
# Imagine it as being in front of each starting square bracket:
# ${[@]} == (x=${@}; ${x[@]}).

__DEFAULT_COLUMNS=80
__TAG_WIDTH=9
__TAG_CHARS=20

# Wrap text in one of the 8 basic ANSI colors.
# - <is prompt> Set to true if the returned string will be used in the command prompt.
# This will add extra escape codes that bracket the invisible characters. Without this,
# Bash gets confused about where the cursor is. The terminal does not understand those
# escapes however, so they are not included when wrapping regular text intended for
# display in the terminal.
declare -A colors=([black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34 [magenta]=35 [cyan]=36 [white]=37)

color() {
  (("$#" == 2 | "$#" == 3)) || {
    info "%s" 'Usage: color <color> <text to print with color> <is prompt>\n'
    info "%s" "Valid colors: ${!colors[*]}"
    return 1
  }
  if [[ $3 == "$true" ]]; then
    esc_start="\["
    esc_end="\]"
  else
    esc_start=""
    esc_end=""
  fi
  # <START>  \033[01;  <COLOR> m  <END>  <TAG>  <START> \033[00m   \n<END>
  printf '%s\033[01;%sm%s%s%s\033[00m%s' "$esc_start" "${colors[${1}]}" "$esc_end" "${2}" "$esc_start" "$esc_end"
}

__p() {
  printf "%s\n" "${*}\n"
  return

  printf -v tag_str "%${__TAG_CHARS}s" "$(color "${@:1}")"
  set -- "${@:3}"
  for x in "${@:3}"; do
    [[ "$x" =~ \n ]] && printf "%s" "$tag_str"
    printf "%s" "$x"
  done
  printf " "
  #  #  printf "${*:0}" "${*:1}"
  # shellcheck disable=SC2059
  printf "${@}"
  #  printf "\n"
}

#__p() {
#  # Print right adjusted. The ANSI color codes must be included in the count.
#  printf "%20s " "$(color "$1" "$2")"
#  shift 2
#  while (("$#")); do
#    local str="$1"
#    shift
#    # Replace the special string "sep" with a repeating string that fills the rest of the line.
#    if [[ "$str" == "sep" ]]; then
#      # If 'sep' is not the last arg, use the next arg as the string to repeat.
#      if (("$#")); then
#        sep_str="$1"
#        shift
#      else
#        sep_str="~"
#      fi
#      str="$(sep "$sep_str")"
#    fi
#    printf '%s' "$str"
#    (("$#")) && printf ' '
#  done
#  printf '\n'
#}

debug() { __p 'magenta' 'DEBUG' "${@}"; }
info() { __p 'green' 'INFO' "${@}"; }
warn() { __p 'yellow' 'WARNING' "${@}"; }
error() { __p 'red' 'ERROR' "${@}"; }

# Debugging for bashrc.d itself.
dbg() {
  #  printf 'dbg input: %s\n' "${@}"
  ((BASHRC_DEBUG)) && debug "${@}"
}

# Test the colors by writing the names of each of the 8 main colors using the named color.
color_test() {
  printf 'Color test: %s\n' "$(for x in "${colors[@]}"; do echo -n "$(color $x $x) "; done; )";
}

# Print a section separator with optional section name
# This prints an optional title and a line of tildes going all across the terminal.
# Usage: dbg/debug/info/warn/error $(sep <optional name of new section>).
sep() {
  local title="$1"
  [[ "$title" ]] && printf -v title '~~ %s ' "$title"
  [[ "$COLUMNS" ]] || COLUMNS="$__DEFAULT_COLUMNS"
  local title_width="${#title}"
  local n=$((COLUMNS - __TAG_WIDTH - title_width - 2))
  ((n < 0)) && n=0
  #  printf "title=%s COLUMNS=%s __TAG_WIDTH=%s title_width=%s n=%s" \
  #    "$title" "$COLUMNS" "$__TAG_WIDTH" "$title_width" "$n"
  printf '%%s%s%s\n' "$title" "$(repeat_str $((COLUMNS - __TAG_WIDTH - title_width)))"
  #    local n=$((COLUMNS - __TAG_WIDTH - title_width))
  #    while ((n--)); do printf '~'; done
  #  )"
}

# Generate a string with
# Usage: <repeat_str> <n (default: columns on terminal)> <str (default: ~)>
repeat_str() {
  # Bash syntax: The "-" replaces empty value with provided literal. The ":" adds
  # support for the rare case of the value being declared but null.
  # TODO: Use this syntax for all funcs in bashrc.d
  n=${1:-"$COLUMNS"}
  s=${2:-"~"}
  while ((n--)); do printf '%s' "$s"; done
}

func_tracer() {
  dbg "$(sep "${FUNCNAME[1]}")"
  dbg '> @ arg: %s\n' "${@}"
  dbg "$(sep "")"
}
