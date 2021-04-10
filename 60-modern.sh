# Replace some common classic commands with more modern alternatives.
# These do better highlighting and most (all?) have integrated GIT support.

# ripgrep is written in Rust. This assumes that `rg` is already in the path.
# ripgrep with paging
cmd_is_installed rg && {
  # Pretty print with syntax highlight colors preserved.
  # Automatically select an engine supporting look-around if used in the expression.
  rgp() { rg --pretty --engine auto "$@" | less -r; }
  # Print only the maths of files with one or more matches
  alias rg-path='rg --files-with-matches'
} || {
  dbg 'ripgrep not installed'
}

# Bat, the amazing cat with wings.
cmd_is_installed 'bat' && {
  alias b='bat'
  alias br='bat --decorations=never'
  alias bp='bat --language=python'
  alias bpr='bat --language=python --decorations=never'
  alias bl='bat --plain'
}

# aliases for 'exa'
# Note: '--git' activates git support in exa. If it causes the aliases to run slowly
# in a git repo, try 'git gc --aggressive'
# TODO: Time the commands and print the tip automatically, maybe even run it automatically?
# shellcheck disable=SC2139
case $(
  cmd_is_installed 'exa'
  echo -n "$?"
) in
0)
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
  ls_args=(
    --group-directories-first
    --color=always
  )
  alias ll="ls -l ${ls_args[*]}"
  alias lw="ls -ltr ${ls_args[*]}"
  alias lo="ls -lt ${ls_args[*]}"
  alias lt="tree ${ls_args[*]}"
  ;;
esac

cmd_is_installed 'nvim' && {
  alias vim='nvim'
}
