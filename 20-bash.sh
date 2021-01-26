# Bash

# Color

# Colored GCC warnings and errors.
export TERM=xterm-256color
export COLORTERM=truecolor
eval "$(dircolors)"



# Prompt
# shellcheck disable=SC2154
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\t\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '

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
