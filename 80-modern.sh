# Replace some common classic commands with more modern alternatives.
# These do better color highlighting and most (all?) have integrated GIT support.

# ripgrep with paging
is_installed rg && {
  # Pretty print with syntax highlight colors preserved
  rgp() { rg --pretty "$@" | less -r; }
  # Print only the maths of files with one or more matches
  alias rg-path='rg --files-with-matches'
} || {
  echo 'ripgrep not installed'
}

# Use bat instead of cat if available
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
  is-installed 'exa'
  echo -n "$?"
) in
0)
  # Have removed --git for now because of 1 second delay in d1_python
  # and a bug where it crashes on dangling symlink.
  # shellcheck disable=SC2191
  exa_args=(
  --bytes --extended --git --group --group-directories-first --long
  --time-style=long-iso
  )
  alias ll="exa --sort name ${exa_args[*]}"
  alias lw="exa --sort new ${exa_args[*]}"
  alias lo="exa --sort old ${exa_args[*]}"
  alias lt="exa --tree ${exa_args[*]}"
  ;;
*)
  alias ll='ls -l --group-directories-first --color=auto'
  ;;
esac

is-installed 'nvim' && {
  alias vim='nvim'
}

# Automatic ls after cd
# Must run after the ll alias is defined.
ls_after_cd() {
  test "$prev" != "$PWD" -a -n "$prev" && ll
  prev="$PWD"
}
PROMPT_COMMAND=ls_after_cd
