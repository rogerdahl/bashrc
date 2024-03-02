# Python, pyenv

#requires 'build-essential'   'Python & pyenv'
#requires 'curl'   'Python & pyenv'
#requires 'llvm'              'Python & pyenv'
#requires 'make'              'Python & pyenv'
#requires 'python3-dev'       'Python & pyenv'
#requires 'python-openssl'    'Python & pyenv'
#requires 'python-setuptools' 'Python & pyenv'
#requires 'libbz2-dev'        'Python & pyenv'
#requires 'libc6-dev'         'Python & pyenv'
#requires 'libdb-dev'         'Python & pyenv'
#requires 'libffi-dev'        'Python & pyenv'
#requires 'libgdbm-dev'       'Python & pyenv'
#requires 'liblzma-dev'       'Python & pyenv'
#requires 'libncurses5-dev'   'Python & pyenv'
#requires 'libncursesw5-dev'  'Python & pyenv'
#requires 'libreadline-dev'   'Python & pyenv'
#requires 'libsqlite3-dev'    'Python & pyenv'
#requires 'libssl-dev'        'Python & pyenv'
#requires 'libz-dev'          'Python & pyenv'
#requires 'tk-dev'            'Python & pyenv'
#requires 'zlib1g'            'Python & pyenv'
#requires 'zlib1g-de'         'Python & pyenv'

pyenv_install_deps() {
  pkg_install \
    'build-essential' \
    'curl' \
    'python3-dev' \
    'python-openssl' \
    'python-setuptools' \
    'libbz2-dev' \
    'libc6-dev' \
    'libdb-dev' \
    'libffi-dev' \
    'libgdbm-dev' \
    'liblzma-dev' \
    'libncurses5-dev' \
    'libncursesw5-dev' \
    'libreadline-dev' \
    'libsqlite3-dev' \
    'libssl-dev' \
    'libz-dev' \
    'tk-dev' \
    'zlib1g-dev'
}

# Ensure that pyenv is installed, active and that there's
# a global venv with latest version of CPython.
pyenv_setup() {
  #  set -x
  #  set -e
  pyenv_install_or_update_pyenv
  PY_LATEST_VER=$(pyenv_find_latest_py_ver)
  printf "Latest CPython: %s\n" "$PY_LATEST_VER"
  pyenv_install_py_ver "$PY_LATEST_VER"
  PY_GLOBAL_VENV="global-$(now)"
  pyenv_install_venv "$PY_LATEST_VER" "$PY_GLOBAL_VENV"
  pyenv global "$PY_GLOBAL_VENV"
  export PY_LATEST_VER
  export PY_GLOBAL_VENV
}


pyenv_install_or_update_pyenv() {
  cmd_is_installed 'pyenv' || {
    curl 'https://pyenv.run' | bash
  }
  pyenv_init
  pyenv_update
}

# Install a virtualenv.
# Installs requested version of Python if not already installed.
# If no version of Python is requested, updates to the latest.
pyenv_install_venv() {
  py_ver="$1"
  venv="$2"
  echo "pyenv_install_venv() py_ver=$py_ver venv=$venv"
  [[ -n $py_ver ]] || [[ -n $venv ]] || {
    echo "Usage $0 <CPython version (x.y.z)> <name of virtualenv>"
    return 1
  }
  pyenv_install_py_ver "$py_ver"
  pyenv_install_basic_packages
  pyenv virtualenv "$py_ver" "$venv"
}

# Install a specific version of Python if it is not already installed.
pyenv_install_py_ver() {
  py_ver="$1"
  [[ -n "$py_ver" ]] || {
    echo "Usage $0 <CPython version (x.y.z)>"
    return 1
  }
  pyenv_is_installed_ver "$py_ver" && return 0
  export CONFIGURE_OPTS=--enable-shared
  export CFLAGS=-O3
  export MAKE_OPTS=-j16
  pyenv install -v "$py_ver"

  pyenv_init
  pip_up

}

# Return the latest version of CPython that is available to pyenv online.
# The returned version may or may not already be installed.
pyenv_find_latest_py_ver() {
  # shellcheck disable=SC2016
  latest_cpython='m/^\s*(\d+\.\d+\.\d+)\s*$/ && { $v=$1 }; END {print $v}'
  printf "%s" "$(pyenv install --list | perl -ne "$latest_cpython")"
}

pyenv_update() {
  pyenv update -v >/dev/null 2>&1
}

pyenv_is_installed_ver() {
  py_ver="$1"
  pyenv versions | env grep --quiet --perl-regex "^\s*$py_ver\s*$"
  return $?
}

pyenv_is_installed_venv() {
  venv="$1"
  pyenv virtualenvs --bare | env grep --quiet --perl-regex "^\s*$venv\s*$"
}

pyenv_init() {
  ! is_dir "$HOME/.pyenv" && {
    printf 'Error: pyenv has not been installed (missing ~/.pyenv)\n'
    return 1
  }
  cmd_is_installed 'pyenv' && {
    printf 'Error: pyenv already initialized\n'
    return 1
  }
  # printf 'Initializing pyenv\n'
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  #    padd "$PYENV_ROOT/bin"
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
}

pyenv_deinit() {
  pyenv_root="$(pyenv root)"

  [[ -z $pyenv_root ]] && {
    printf 'Error: pyenv command not available (already deinitialized?)\n'
    return 1
  }

  [[ -n ${PYENV_VIRTUAL_ENV+x} ]] && {
    printf 'Deactivating current pyenv virtualenv\n'
    pyenv deactivate
  }

  printf 'Deactivating pyenv\n'

  # Idiomatic way to split the path. IFS is modified only for the read. Global IFS is
  # not changed.
  IFS=":" read -r -d '' -a path_arr <<<"$PATH"
  declare -a new_path

  for p in "${path_arr[@]}"; do
    echo "$p"
    [[ $p =~ $pyenv_root ]] || {
      abs_path="$(cd "$(dirname "$p")" 2>/dev/null && pwd)/$(basename "$p")"
      [[ -n $abs_path ]] && {
        new_path+=("$abs_path")
      }
    }
  done

  sep=':'
  printf -v PATH '%s' "$(join_arr new_path sep)"
}

# pip

pip_init() {
  pip_up
  pip_install_core
}

pip_install_core() {
  pip install --upgrade pip
  pip install wheel virtualenv
}

pip_up() {
  pip_path="$(pyenv which pip)"
  [[ -n "$(find "$pip_path" -not -newerct '3 days ago')" ]] && {
    pip_up_now
    touch "$pip_path"
  }
}

pip_up_now() {
  pip install --upgrade pip
}

pip_upgrade_all() {
  pip list --outdated --format=freeze |
    grep -v "^\-e" |
    cut -d = -f 1 |
    xargs -n1 env pip install -U
}

# Install wheel if not already installed.
pip_is_package_installed() {
  pkg="$1"
  pip freeze | grep -qi "^${pkg}\b"
  return $?
}

#alias pip='pip_up; pip'

####################

if [ -d "${HOME}/.pyenv" ]; then
  pyenv_init
fi

