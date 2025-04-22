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

# Enable regex glob.
# - Syntax +(regex). E.g.: ls /tmp/file.+([0-9])
shopt -s extglob

# Enable recursive directory glob.
# - Syntax: `**` expands recursively to all matching nested paths.
# - E.g.:
# -- All files and dirs:           printf '%s\n' **
# -- All dirs:                     printf '%s\n' **/
# -- All .myext files in all dirs: printf '%s\n' **/*.myext
# - I don't think there's a way to match all files without also matching all dirs?
# - `**` can be used with a partial dir name, but each parent dir must match the glob,
# so `x**` will not match `x1/x2/y/x3`. Instead, combine `**`, with regular `*` glob.
# - E.g.:
# -- All dirs with names starting with `x` (regardless of parent names):
# printf '%s\n'**/x*/
shopt -s globstar

# Enable glob that does not match anything to return an error instead of falling back to
# being interpreted as a literal dir or file name.
# - Fallback to literal name is confusing, and never what one wants, since wildcard
# characters (`*`, `?`) are avoided in dir and path names. Actually, they're pretty much
# only needed in literal context to fix errors caused by not using `failglob` :)
# - To pass globs and wildcard characters to commands without triggering the error,
# single quote them.
# - E.g.:
# - `vim *.py` returns an error if there are no `.py` files in the current dir instead
#shopt -s failglob

# Enable glob that does match anything to fall back to zero arguments (an empty array)
# instead of a literal dir or file name.
# - Not enabled by default, as I think `failglob` is a much better way to handle
# non-matching globs.
# shopt -s nullglob

# Enable matching dot-files with `*`.
# - Not enabled by default, as it's often convenient to not have dot files (which are
# usually 'invisible'), included in globs. WITHOUT dotglob, use two globs to include
# dot files, and combine with brace expansion (which is done before globbing) to avoid
# repeating a directory path. E.g.,:
# WITHOUT dotglob: printf '%s\n' a/b/c/{.*,*}
# shopt -s dotglob

# Enable matching dot-files without matching '.' and '..'
# E.g.:
# All dot files in current dir (.config, .bashrc, etc), but not `.` (this dir itself) or
# `..` (parent dir):
# printf '%s\n' .*
GLOBIGNORE=.:..

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# CD into a directory by typing just the name
shopt -s autocd

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
