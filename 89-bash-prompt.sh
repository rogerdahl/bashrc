# Bash prompt

# This sets up the command line prompt. We source it after all the scripts that may
# change the environment, so that it has the full context of the initialized bash shell
# to draw on.

# Debugging:
# - BASHRC_DEBUG is normally turned off by init.sh just before exit, so debug output is
# not shown. To enable debug output for this function, `export BASHRC_DEBUG='y'` in the
# interactive shell.

AUTO_LS_AFTER_CD="y"
#export GIT_PS1_SHOWUPSTREAM='auto'

export PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

function __prompt_command() {
  local exit_code=${PIPESTATUS[-1]} #"$?"

  [[ -n "$AUTO_LS_AFTER_CD" ]] && {
    test "$prev" != "$PWD" -a -n "$prev" && ll
    prev="$PWD"
  }

  PS1="$ "
  #  PS1="X"
  local sep=" "

  # Exit code of the previous command
  if [[ "$exit_code" != "0" ]]; then
    add_str PS1 "$(space_quote "$(color 'red' "exit=$exit_code")")" "$sep"
  else
    add_str PS1 "$(space_quote "$(color 'green' "ok")")" "$sep"
  fi

  # Git status
  # Add a character describing the status vs. remote.
  local git="$(__git_ps1 "%s")"
  [[ -n "$git" ]] && {
    add_str PS1 "$(space_quote "$(color 'blue' "git=$git")")" "$sep"
  }

  # CWD relative to home if under home, and absolute otherwise (tries to match "\w").
  local cwd="${PWD/$HOME/\~}"
  # Use basename of CWD if full CWD is more than half the width of the screen.
  [[ ${#cwd} -gt $((COLUMNS / 2)) ]] && cwd="$(basename "$cwd")"
  # current working directory, full path
  add_str PS1 "$(space_quote "$(color 'blue' "$cwd")")" "$sep"
  # 24h hour:minute:second
  add_str PS1 "$(space_quote "$(color 'yellow' '\t')")" "$sep"
  # user @ hostname
  add_str PS1 "$(space_quote "$(color 'blue' '\u@\h')")" "$sep"
}
