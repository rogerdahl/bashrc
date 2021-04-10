# vim

export VIM_CONFIG="$XDG_CONFIG_HOME/nvim"

install_vimproc() (
  [[ -n "$XDG_CONFIG_HOME" ]] || {
    echo 'Error installing vimproc: XDG_CONFIG_HOME not set'
    return 1
  }

  # Using parens instead of curlies for the body of the function causes
  # the program to run in a subshell, so changes to CWD become local.
  cd /tmp
  is_dir "vimproc.vim" || git clone http://github.com/Shougo/vimproc.vim
  cd vimproc.vim
  make
  rsync -r ./autoload/* ./plugin/* ./lib/* "$VIM_CONFIG/"
)
