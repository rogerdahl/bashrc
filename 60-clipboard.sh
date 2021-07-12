# Clipboard and command line history

# To clipboard:

# stdout -> clip: clip
# It's usually more convenient not to have trailing newlines in the clipboard, so they
# are stripped out here.
clip() {
  perl -pe 'chomp if eof' | xclip -se c;
}

# realpath -> clip: pathc <path>
pathc() {
  realpath "$@" | clip;
}

# echo -> clip: echoc <string>
# echo arbitrary string to the clipboard
echoc() {
  echo "$@" | clip;
}

# history -> clip: lastc <number of lines, default 1>
histc() {
  line_count=$(("${1:-1}" + 1))
  history "$line_count" \
    | head -n "$((line_count - 1))" \
    | perl -pe 's/.{36}//' \
    | clip;
  printf 'Copied history to clipboard\n'
}

# file -> clip: filec <path>
# Copy file to clipboard
filec() {
  [[ -z $1 ]] && {
    printf 'Copy file to clipboard\n'
    printf 'Usage: filec <new or existing file path>\n'
    return 1
  }
  clip < "$1"
  printf 'Copied file to clipboard\n'
}

# clip -> file: cfile <path>
# Like `clip >> path`, but there's no chance of a typo missing one ">" and clobbering the
# file.
cfile() {
  [[ -z $1 ]] && {
    printf 'Append clipboard to file\n'
    printf 'Usage: cfile <new or existing file path>\n'
    return 1
  }
  xclip -o >> "$1"
}

# History ->
# Copy last N (default = 1) command line history to destination

# -> stdout
hout() {
#  printf 'Write command line history to stdout\n'
#  printf 'Usage: hout <N lines, default = 1>\n'
  line_count=$(("${1:-1}" + 1))
  history "$line_count" \
    | head -n "$((line_count - 1))" \
    | perl -pe 's/.{36}//' ;
}

# history -> file
# File is created if it doesn't exist.
# Always appends.
# Usage: <file> [N lines, default = 1]
hfile() {
  path="$1"
  [[ -z "$path" ]] && {
    printf 'Append command line history to file\n'
    printf 'Usage: hfile <new or existing path> [N lines, default = 1]\n'
    return 1
  }
  line_count="${2:-1}"
  hout "$line_count" >> "$path"
  printf '\n'
}

_reminders="
To clipboard:

stdout ->   clip: clip
realpath -> clip: pathc <path>
echo -> clip:     echoc <string>
history -> clip:  lastc <number of lines, default 1>
file -> clip:     filec <path>

From clipboard:

clip -> file      cfile <path>
clip -> command:  ctrl+v
clip -> file:     cat > file, ctrl+v, ctrl+d
"

_print() {
  printf '%s' "$_reminders"
}

alias pclip=_print
alias eclip=_print
alias oclip=_print
alias cclip=_print
