# Bash prompt

# This sets up the command line prompt. We can do this anywhere because the prompt function
# does not get called until Bash needs to generate a prompt, and that happens after
# the environment is fully initialized.

# Debugging:
#
# - Unless specifically debugging the prompt function, getting a bunch of debug output
# every time the prompt is displayed is decidedly unhelpful. So we have an additional
# setting here that must be set to `true` in order to get debug output here. When set to
# `false`, this variable overrides the setting in `BASHRC_DEBUG`, forcing it to `false`
# while the function runs.
# - The prompt requires some special escape codes for colors. Those are are also
# logged to the terminal by the functions that generate them. As the terminal does not
# understand them, they show up as visible "\[" characters.

#
ENABLE_PROMPT_DEBUG=false

AUTO_LS_AFTER_CD=true
#export GIT_PS1_SHOWUPSTREAM='auto'


#export PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

#function __prompt_command() {
#	local exit_code=${PIPESTATUS[-1]} #"$?"
#
#  (( ENABLE_PROMPT_DEBUG )) || {
#    tmp_debug=$BASHRC_DEBUG
#    BASHRC_DEBUG=false
#  }
#
#  (( AUTO_LS_AFTER_CD )) && {
#		test "$prev" != "$PWD" -a -n "$prev" && ll
#		prev="$PWD"
#	}
#
#	PS1="$ "
#	#  PS1="X"
#	local sep=" "
#
#	# Exit code of the previous command
#	if [[ "$exit_code" != "0" ]]; then
#		add_str PS1 "$(space_quote "$(color 'red' "exit=$exit_code" true)")" "$sep"
#	else
#		add_str PS1 "$(space_quote "$(color 'green' "ok" true)")" "$sep"
#	fi
#
#	# Git status
#	# Add a character describing the status vs. remote.
#	local git="$(__git_ps1 '%s')"
#	[[ -n "$git" ]] && {
#		add_str PS1 "$(space_quote "$(color 'blue' "git=$git" true)")" "$sep"
#	}
#
#	# CWD relative to home if under home, and absolute otherwise (tries to match "\w").
#	local cwd="${PWD/$HOME/\~}"
#	# Use basename of CWD if full CWD is more than half the width of the screen.
#	[[ ${#cwd} -gt $(( COLUMNS / 2 )) ]] && cwd="$(basename "$cwd")"
#	# current working directory, full path
#	add_str PS1 "$(space_quote "$(color 'blue' "$cwd" true)")" "$sep"
#	# 24h hour:minute:second
#	add_str PS1 "$(space_quote "$(color 'yellow' '\t' true)")" "$sep"
#	# user @ hostname
#	add_str PS1 "$(space_quote "$(color 'blue' '\u@\h' true)")" "$sep"
#
#  (( ENABLE_PROMPT_DEBUG )) || {
#    BASHRC_DEBUG=$tmp_debug
#  }
#}

prompt_simple() {
  export PROMPT_COMMAND="{ PS1='\w $ '; }"
}

