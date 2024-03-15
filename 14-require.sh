# Simple system to track and install dependencies of the various bashrc.d modules.

# Create an associative array (dict). We use the key for package name and value for
# comments, such as what's needed from the package.
declare -A REQ_ARR
export REQ_ARR

# Check if packages are present and, if they are not, add them to a list of missing
# requirements. If all the packages in the list are present, exit with 0 (true), else 1
# (false).
require() {
  missing=0
  for pkg in "$@"; do
    pkg_is_installed "$pkg"
    [[ $? -ne 0 ]] && {
      echo "Missing package: $pkg"
      missing=1
    }
  done
  return $missing
}

require_cmd() {
  arg=("$@") req=('name of command required to be in PATH') opt=()
  usage arg req opt && return 1
  cmd_str="$1"
  abort
  cmd_is_installed cmd_str || {
    printf >&2 "Missing a required command: %s\n" "$cmd_str"
  }
}

list_deps() {
  for pkg in "${!REQ_ARR[@]}"; do
    echo "$pkg (${REQ_ARR[$pkg]})"
  done
}

# Install any missing packages.
pkg_install_missing() {
  [[ -n "${REQ_ARR[*]}" ]] || {
    pkg_install "${REQ_ARR[@]}"
  }
}

# Install a list of packages.
pkg_install() {
  sudo apt-get install --no-upgrade --yes "$@"
}

# Exit with status 0 (exists) or 1 (does not exist) for a given package name.
pkg_is_installed() {
  q="$(dpkg-query -W -f '${Status}\n' "${1}" 2>&1)"
  [[ "$q" =~ is\ installed ]] && return 1
  return 0
}
