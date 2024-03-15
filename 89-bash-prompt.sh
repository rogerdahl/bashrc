# Bash prompt

# This sets up the command line prompt. We source it after all the scripts that may
# change the environment, so that it has the full context of the initialized bash shell
# to draw on.

# Debugging:
# This script runs every time a new prompt is to be displayed, so anything that it
# writes to stdout or stderr is printed before every prompt. Unless specifically
# debugging the script, the output interferes with other use, including debugging
# of other scripts. So output from this script, including debug level output, is
# controlled separately from other output, and is normally disabled.

AUTO_LS_AFTER_CD=true
#export GIT_PS1_SHOWUPSTREAM='auto'

PROMPT_SEP_STR=" "

# Func to gen PS1 after CMDs
export PROMPT_COMMAND=__prompt_command

prompt_simple() {
  export PROMPT_COMMAND='{ PS1="$ "; }'
}

prev_exit='x'

__prompt_command() {
  cur_exit="${PIPESTATUS[-1]}"

  ((AUTO_LS_AFTER_CD)) && {
    test "$prev" != "$PWD" -a -n "$prev" && ll
    prev="$PWD"
  }

  PS1=""

  # user @ hostname
  PS1+="$(quote_space "$(color_prompt 'blue' '\u@\h')")$PROMPT_SEP_STR"

  # 24h hour:minute:second
  PS1+="$(quote_space "$(color_prompt 'yellow' '\t')")$PROMPT_SEP_STR"

  # CWD, relative to home if under home, and absolute otherwise (tries to match "\w")
  local cwd="${PWD/$HOME/\~}"
  # Use basename of CWD if full CWD is more than half the width of the screen.
  [[ ${#cwd} -gt $((COLUMNS / 2)) ]] && cwd="$(basename "$cwd")"
  PS1+="$(quote_space "$(color_prompt 'blue' "$cwd")")$PROMPT_SEP_STR"

  # Exit code of the previous command
  (( cur_exit == prev_exit )) || {
    if (( cur_exit )); then
      PS1+="$(quote_space "$(color_prompt 'red' "$cur_exit")")$PROMPT_SEP_STR"
    else
      PS1+="$(quote_space "$(color_prompt 'green' 'ok')")$PROMPT_SEP_STR"
    fi
  }
  prev_exit="$cur_exit"

  # Git status
  # Add a character describing the status vs. remote.
  local git="$(__git_ps1 '%s')"
  [[ -n "$git" ]] && {
    PS1+="$(quote_space "$(color_prompt 'magenta' "$git")")$PROMPT_SEP_STR"
  }

  PS1+="\$$PROMPT_SEP_STR"
}

# Wrap a string with ANSI color codes for use in the prompt. BASH requires characters
# that don't advance the caret to be wrapped with escape codes, `\[` and `\]`, when
# used in the prompt.
color_prompt() {
  printf "\\[\033[01;%sm\\]%s\\[\033[00m\\]\n" "${ANSI_COLORS[$1]}" "$2"
}
