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

# Ensure that pyenv is installed, active and that there's
# a global venv with latest version of CPython.
pyenv-setup() {
  #  set -x
  #  set -e
  pyenv-install-or-update-pyenv
  PY_LATEST_VER=$(pyenv-find-latest-py-ver)
  printf "Latest CPython: %s\n" "$PY_LATEST_VER"
  pyenv-install-py-ver "$PY_LATEST_VER"
  PY_GLOBAL_VENV="global-$(now)"
  pyenv-install-venv "$PY_LATEST_VER" "$PY_GLOBAL_VENV"
  pyenv global "$PY_GLOBAL_VENV"
  export PY_LATEST_VER
  export PY_GLOBAL_VENV
}

pyenv-install-or-update-pyenv() {
  is-installed 'pyenv' || {
    curl 'https://pyenv.run' | bash
  }
  pyenv-init
  pyenv-update
}

# Install a virtualenv.
# Installs requested version of Python if not already installed.
# If no version of Python is requested, updates to the latest.
pyenv-install-venv() {
  py_ver="$1"
  venv="$2"
  echo "pyenv-install-venv() py_ver=$py_ver venv=$venv"
  [[ -n "$py_ver" ]] || [[ -n "$venv" ]] || {
    echo "Usage $0 <CPython version (x.y.z)> <name of virtualenv>"
    return 1
  }
  pyenv-install-py-ver "$py_ver"
  pyenv-install-basic-packages
  pyenv virtualenv "$py_ver" "$venv"
}

# Install a specific version of Python if it is not already installed.
pyenv-install-py-ver() {
  py_ver="$1"
  [[ -n "$py_ver" ]] || {
    echo "Usage $0 <CPython version (x.y.z)>"
    return 1
  }
  pyenv-is-installed-ver "$py_ver" && return 0
  export CONFIGURE_OPTS=--enable-shared
  export CFLAGS=-O3
  export MAKE_OPTS=-j16
  pyenv install -v "$py_ver"

  pyenv-init
  pip-up

}

# Return the latest version of CPython that is available to pyenv online.
# The returned version may or may not already be installed.
pyenv-find-latest-py-ver() {
  # shellcheck disable=SC2016
  latest_cpython='m/^\s*(\d+\.\d+\.\d+)\s*$/ && { $v=$1 }; END {print $v}'
  printf "%s" "$(pyenv install --list | perl -ne "$latest_cpython")"
}

pyenv-update() {
  pyenv update -v >/dev/null 2>&1
}

pyenv-is-installed-ver() {
  py_ver="$1"
  pyenv versions | env grep --quiet --perl-regex "^\s*$py_ver\s*$"
  return $?
}

pyenv-is-installed-venv() {
  venv="$1"
  pyenv virtualenvs --bare | env grep --quiet --perl-regex "^\s*$venv\s*$"
}

pyenv-init() {
  if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    padd "$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
}

pyenv-init

# pip

pip-init() {
  pip-up
  pip-install-core
}

pip-install-core() {
  pip install --upgrade pip
  pip install wheel virtualenv
}

pip-up() {
  pip_path="$(pyenv which pip)"
  [[ -n "$(find "$pip_path" -not -newerct '3 days ago')" ]] && {
    pip-up-now
    touch "$pip_path"
  }
}

pip-up-now() {
  pip install --upgrade pip
}

pip-upgrade-all() {
  pip list --outdated --format=freeze |
    grep -v "^\-e" |
    cut -d = -f 1 |
    xargs -n1 env pip install -U
}

# Install wheel if not already installed.
pip-is-package-installed() {
  pkg="$1"
  pip freeze | grep -qi "^${pkg}\b"
  return $?
}

#alias pip='pip-up; pip'
