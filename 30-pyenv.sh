# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  padd "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

