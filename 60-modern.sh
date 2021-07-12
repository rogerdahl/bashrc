# Replace some common classic commands with more modern alternatives.
# These do better highlighting and most (all?) have integrated GIT support.

# ripgrep is written in Rust. This assumes that `rg` is already in the path.
# ripgrep with paging
cmd_is_installed rg && {
  # Pretty print with syntax highlight colors preserved.
  # Automatically select an engine supporting look-around if used in the expression.
  rgp() { rg --pretty --engine auto "$@" --color always | less -r; }
  # Print only the maths of files with one or more matches
  alias rg-path='rg --files-with-matches'
  # Automatically select best engine for the given regex
  alias rg='rg --engine auto'
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
  alias bx='bat --language=xml'
  # TODO: Include theme: --theme 'Monokai Extended Bright'
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
  _EXA_COLORS=(
    # Fg: 38;2;R;G;B
    # bg: 48;2;R;G;B
    # Tone down the "@" extended attribute indicator (white by defalt)
    'xa=38;2;00;150;150'
    #'xa=48;2;255;255;255'
  )
  _IFS="$IFS"
  IFS=':'; export EXA_COLORS="${_EXA_COLORS[*]}"
  IFS="$_IFS"

  # shellcheck disable=SC2191
  exa_args=(
    --bytes
    --git
    --group
    --group-directories-first
    --long
    --time-style=long-iso
    --color=always
    #--color-scale
  )
  alias ll="exa --sort name ${exa_args[*]}"
  alias lw="exa --sort new ${exa_args[*]}"
  alias lo="exa --sort old ${exa_args[*]}"
  alias lt="exa --tree ${exa_args[*]}"
  alias le="exa --extended ${exa_args[*]}"
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

# alias for du
# cargo install du-dust
# TODO
#Usage: dust
#Usage: dust <dir>
#Usage: dust <dir>  <another_dir> <and_more>
#Usage: dust -p <dir>  (full-path - does not shorten the path of the subdirectories)
#Usage: dust -s <dir>  (apparent-size - shows the length of the file as opposed to the amount of disk space it uses)
#Usage: dust -n 30  <dir>  (shows 30 directories instead of the default)
#Usage: dust -d 3  <dir>  (shows 3 levels of subdirectories)
#Usage: dust -r  <dir>  (reverse order of output, with root at the lowest)
#Usage: dust -x  <dir>  (only show directories on the same filesystem)
#Usage: dust -X ignore  <dir>  (ignore all files and directories with the name 'ignore')
#Usage: dust -b <dir>  (do not show percentages or draw ASCII bars)

