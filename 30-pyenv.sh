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
function pyenv-setup() {
  #  set -x
  #  set -e
  pyenv-install-or-update-pyenv
  PY_LATEST_VER=$(pyenv-find-latest-py-ver)
  printf "Latest CPython: %s\n" "$PY_LATEST_VER"
  pyenv-install-py-ver "$PY_LATEST_VER"
  pyenv-init
  pipup
  PY_GLOBAL_VENV="global-$(iso-now)"
  pyenv-install-venv "$PY_LATEST_VER" "$PY_GLOBAL_VENV"
  pyenv global "$PY_GLOBAL_VENV"
  export PY_LATEST_VER
  export PY_GLOBAL_VENV
}

function pyenv-install-or-update-pyenv() {
  is_installed 'pyenv' || {
    curl 'https://pyenv.run' | bash
  }
  pyenv-init
  pyenv update -v
}

# Install a virtualenv.
# Installs requested version of Python if not already installed.
# If no version of Python is requested, updates to the latest.
function pyenv-install-venv() {
  py_ver="$1"
  venv="$2"
  [[ -n "$py_ver" ]] || [[ -n "$venv" ]] || {
    echo "Usage $0 <CPython version (x.y.z)> <name of virtualenv>"
    return 1
  }
  pyenv-install-py-ver "$py_ver"
  pyenv virtualenv -v "$py_ver" "$venv"
}

# Install a specific version of Python if it is not already installed.
function pyenv-install-py-ver() {
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
}

# Return the latest version of CPython that is available to pyenv online.
# The returned version may or may not already be installed.
function pyenv-find-latest-py-ver() {
  pyenv -v update >/dev/null 2>&1
  # shellcheck disable=SC2016
  latest_cpython='m/^\s*(\d+\.\d+\.\d+)\s*$/ && { $v=$1 }; END {print $v}'
  printf "%s" "$(pyenv install --list | perl -ne "$latest_cpython")"
}

function pyenv-is-installed-ver() {
  py_ver="$1"
  pyenv versions | env grep --quiet --perl-regex "^\s*$py_ver\s*$"
  return $?
}

function pyenv-init() {
  if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    padd "$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
}

function pipup() {
  pip install --upgrade pip wheel
}

pyenv-init
