# Global settings

# shellcheck disable=SC2034
export false=0
export true=1

# Set to true or false
export BASHRC_DEBUG=false
#export BASHRC_DEBUG=true

# 'dbg' not yet available
(( BASHRC_DEBUG )) && printf 'Debug level logging enabled\n'

export XDG_CONFIG_HOME="$HOME/.config"

# Base settings for ls, du and other commands from the coreutils package.
#
# To add to these instead of overwriting them, use 'add_str'.

# Group file sizes by thousands
export BLOCK_SIZE="'1"
# Don't append type indicator character to the end of filenames (@, /, etc)
export QUOTING_STYLE=literal
# Sensible time format (ISO 8601 with space instead of "T" separator)
export TIME_STYLE='+%Y-%m-%d %H:%M:%S'

# Enabled multithreading for xz
export XZ_OPT="--threads=16"

# The primary environment variable affecting this is LC_COLLATE.
# If LC_ALL is set though, it trumps all specific LC_ values.
# If neither LC_ALL nor LC_COLLATE are set, it falls back on LANG.
# If that is not set, it defaults to locale C
