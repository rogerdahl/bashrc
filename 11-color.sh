# Logging and print with colors

__DEFAULT_COLUMNS=80

# Wrap text in one of the 8 basic ANSI colors.
declare -A ANSI_COLORS=([black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34 [magenta]=35 [cyan]=36 [white]=37)

color() {
  [[ $# -eq 2 ]] || {
    printf "Usage: color black/red/green/yellow/blue/magenta/cyan/white <text to print in color>\n"
    return 1
  }
  # Bash syntax:
  # \033 is the escape character in octal, 27 decimal, 0x1b hex.
  printf "\033[01;%sm%s\033[00m\n" "${ANSI_COLORS[${1}]}" "${2}"
}

# Print a line with severity level. The severity level is colorized when writing to a
# tty. Multiple arguments are printed on the same line separarated by a single space.
# The special string "sep" causes the remaining part of the line to be filled with a
# repeated character. The character is "~" by default. Another character can be selected
# by adding it after "sep". E.g. `pdebug "my message" sep =`  ,
#    DEBUG my message ===========================================
pdebug() { __p 'magenta' 'DEBUG' "${@}"; }
pinfo() { __p 'green' 'INFO' "${@}"; }
pwarn() { __p 'yellow' 'WARNING' "${@}"; }
perror() { __p 'red' 'ERROR' "${@}"; }
pln() { printf "\n"; }

dbg() {
  [[ "$DEBUG" ]] && pdebug "$@"
}

__p() {
  # Print right adjusted. The ANSI color codes must be included in the count.
  printf "%20s " "$(color "$1" "$2")"
  shift 2
  while (("$#")); do
    local str="$1"
    shift
    # Replace the special string "sep" with a repeating string that fills the rest of the line.
    if [[ "$str" == "sep" ]]; then
      # If 'sep' is not the last arg, use the next arg as the string to repeat.
      if (("$#")); then
        sep_str="$1"
        shift
      else
        sep_str="~"
      fi
      str="$(sep "$sep_str")"
    fi
    printf '%s' "$str"
    (("$#")) && printf ' '
  done
  printf '\n'
}

# Print a section separator with optional section name
# This prints an optional title and a line of tildes going all across the terminal.
sep() {
  local title="$1"
  [[ "$title" ]] && title=" $title "
  local title_width="${#title}"
  local n=$((COLUMNS - title_width - 2))
  ((n < 0)) && n=0
  [[ "$COLUMNS" ]] || COLUMNS="$__DEFAULT_COLUMNS"
  printf '~~%s%s\n' "$title" "$(repeat_str $n)"
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
