# Global settings

# shellcheck disable=SC2034
export false=0
export true=1

# Set to true or false
export BASHRC_DEBUG=true
# (( BASHRC_DEBUG )) && printf 'Debugging...\n'

# Base settings for ls, du and other commands from the coreutils package.
#
# To add to these instead of overwriting them, use 'add_str'.

# Group file sizes by thousands
export BLOCK_SIZE="'1"
# Don't append type indicator character to the end of filenames (@, /, etc)
export QUOTING_STYLE=literal
# Sensible time format (ISO 8601 with space instead of "T" separator)
export TIME_STYLE='+%Y-%m-%d %H:%M:%S'
# Make 'less' scroll lines just before a match into view (shows context)
# and pass though ANSI color codes.
export LESS="${LESS}j5 -R"

# Enabled multithreading for xz
export XZ_OPT="--threads=16"
