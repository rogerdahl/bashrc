# Replace some common classic commands with more modern alternatives.
# These do better color highlighting and most (all?) have integrated GIT support.

# ripgrep with paging
function rgp () { rg --pretty "$@" | less -r; }


# Use bat intead of cat if available
if command -v bat >/dev/null 2>&1; then
  alias b="bat --language=python"
  alias cat=bat
  alias catp="bat --plain"
fi
# Modern alterantives for commonly used commands

# Use exa for ll if available
# If ll in a git repo is slow, run 'git gc --aggressive'
if command -v exa >/dev/null 2>&1; then
  exa_args='--long --git --bytes --group --time-style=long-iso --group-directories-first --extended'
  # Have removed --git for now because of 1 second delay in d1_python
  # and a bug where it crashes on dangling symlink.
  exa_args='--long --bytes --group --time-style=long-iso --group-directories-first --extended'
  alias ll="exa --sort name $exa_args"
  alias lw="exa --sort new $exa_args"
  alias lo="exa --sort old $exa_args"
  alias lt="exa --tree"
else
  alias ll='ls -l --group-directories-first --color=auto'
fi

if command -v bat >/dev/null 2>&1; then
   alias cat=bat
   alias b='bat --language python'
   alias br='bat --language python --decorations=never'
fi

# Always use NeoVim if available
is_installed 'nvim' && {
  # The linking here caused trouble with spacevim.
  #  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  #  ln -sf "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"
  #  ln -sf "$HOME/.vimrc" "$XDG_CONFIG_HOME/nvim/init.vim"
  alias vim='nvim'
}
