# Replace some common classic commands with more modern alternatives.
# These do better highlighting and most (all?) have integrated GIT support.

# ripgrep with paging
is_installed rg && {
	# Pretty print with syntax highlight colors preserved
	rgp() { rg --pretty "$@" | less -r; }
	# Print only the maths of files with one or more matches
	alias rg-path='rg --files-with-matches'
} || {
	dbg 'ripgrep not installed'
}

# Bat, the amazing cat with wings.
is_installed 'bat' && {
	alias b='bat'
	alias br='bat --decorations=never'
	alias bp='bat --language=python'
	alias bpr='bat --language=python --decorations=never'
	alias bl='bat --plain'
}

# If ll in a git repo is slow, run 'git gc --aggressive'
# shellcheck disable=SC2139
case $(
	is_installed 'exa'
	echo -n "$?"
) in
0)
	# Have removed --git for now because of 1 second delay in d1_python
	# and a bug where it crashes on dangling symlink.
	# shellcheck disable=SC2191
	exa_args=(
		--bytes
		--extended
		--git
		--group
		--group-directories-first
		--long
		--time-style=long-iso
		--color=always
	)
	alias ll="exa --sort name ${exa_args[*]}"
	alias lw="exa --sort new ${exa_args[*]}"
	alias lo="exa --sort old ${exa_args[*]}"
	alias lt="exa --tree ${exa_args[*]}"
	watch_tree() { watch -n .5 --difference --color lt --sort=time --reverse "$1"; }
	;;
*)
	alias ll='ls -l --group-directories-first --color=auto'
	;;
esac

is_installed 'nvim' && {
	alias vim='nvim'
}
