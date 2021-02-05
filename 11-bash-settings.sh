# Bash

export SHELL=/bin/bash

# Implicitly export everything.
# OFF for now, because it breaks extglob (regex glob), as in the 'rc_push' function in
# the 'git' numbered script.
# set -a

# Print source lines as they are executed.
# set -x

# Color

# Colored GCC warnings and errors.
export TERM=xterm-256color
export COLORTERM=truecolor
eval "$(dircolors)"

# Misc global settings

# Allow regex in glob.
# Syntax +(regex). E.g.: ls /tmp/file.+([0-9])
# Note: Also set in util.sh.
shopt -s extglob
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# CD into a directory by typing just the name
shopt -s autocd
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# History

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth:erasedups

# Append to the history file, don't overwrite it

# The default HISTCONTROL setting normally includes "ignoreboth", which causes lines
# starting with one or more spaces not to be added to the history. Since leading spaces
# are often included accidentally when copy/pasting commands into the shell, it's
# removed here.
HISTCONTROL=erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

# History length
HISTSIZE=1000
HISTFILESIZE=2000

# Include timestamps
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%s  '

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will match all files and zero or
# more directories and subdirectories.
# CD into a directory by typing just the name
shopt -s autocd

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set bash option
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
declare -A set_opt=([exit_on_error]='e' [print_trace]='x')
set_opt() {
  [[ $# -eq 2 ]] || {
    printf "Usage: set_opt <name of option> <true/false>\n"
    return 1
  }
  k="${set_opt[$1]}"
  v="$2"
  case "$v" in
  true) x="-" ;;
  false) x="+" ;;
  esac

  set "$k" "$x"
}