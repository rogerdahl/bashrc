# Bash prompt

# This sets up the command line prompt. We source it after all the scripts that may
# change the environment, so that it has the full context of the initialized bash shell
# to draw on.

# Debugging:
# - BASHRC_DEBUG is normally turned off by init.sh just before exit, so debug output is
# not shown. To enable debug output for this function, `export BASHRC_DEBUG='y'` in the
# interactive shell.

AUTO_LS_AFTER_CD=true
#export GIT_PS1_SHOWUPSTREAM='auto'

# By default, we disable debugging while creating the prompt. Any string is "true"
DISABLE_PROMPT_DEBUG=true

PROMPT_SEP_STR=" "

export PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

prompt_simple() {
  export PROMPT_COMMAND='{ PS1="$ "; }'
}

prev_exit='x'

function __prompt_command() {
  cur_exit="${PIPESTATUS[-1]}"

  ((DISABLE_PROMPT_DEBUG)) && {
    tmp_debug=$BASHRC_DEBUG
    BASHRC_DEBUG=false
  }

  ((AUTO_LS_AFTER_CD)) && {
    test "$prev" != "$PWD" -a -n "$prev" && ll
    prev="$PWD"
  }

  PS1=""

  # user @ hostname
  PS1+="$(space_quote "$(color 'blue' '\u@\h')")$PROMPT_SEP_STR"

  # 24h hour:minute:second
  PS1+="$(space_quote "$(color 'yellow' '\t')")$PROMPT_SEP_STR"

  # CWD, relative to home if under home, and absolute otherwise (tries to match "\w")
  local cwd="${PWD/$HOME/\~}"
  # Use basename of CWD if full CWD is more than half the width of the screen.
  [[ ${#cwd} -gt $((COLUMNS / 2)) ]] && cwd="$(basename "$cwd")"
  PS1+="$(space_quote "$(color 'blue' "$cwd")")$PROMPT_SEP_STR"

  # Exit code of the previous command
  (( cur_exit == prev_exit )) || {
    if (( cur_exit )); then
      PS1+="$(space_quote "$(color 'red' "$cur_exit")")$PROMPT_SEP_STR"
    else
      PS1+="$(space_quote "$(color 'green' "ok")")$PROMPT_SEP_STR"
    fi
  }
  prev_exit="$cur_exit"

  # Git status
  # Add a character describing the status vs. remote.
  local git="$(__git_ps1 '%s')"
  [[ -n "$git" ]] && {
    PS1+="$(space_quote "$(color 'magenta' "$git")")$PROMPT_SEP_STR"
  }

  PS1+="\$$PROMPT_SEP_STR"

  ((DISABLE_PROMPT_DEBUG)) && {
    BASHRC_DEBUG=$tmp_debug
  }
}
