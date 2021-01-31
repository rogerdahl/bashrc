# Simple system to discover and install dependencies of the various bashrc.d modules.

# Create an associative array (dict). We use the key for package name and value for
# comments, such as what's needed from the package.
declare -A REQ_ARR
export REQ_ARR

# Check if packages are present and, if they are not, add them to a list of missing
# requirements. If all the packages in the list are present, return true. Else return
# false.
require() {
  missing=0
  for pkg in "$@"; do
#    echo "$pkg"
    [[ "$(pkg-is-installed "$pkg")" != '1' ]] && { echo "Missing package: $pkg"; missing=1; }
  done
  return $missing
}

function list_deps() {
  for req in "${!REQ_ARR[@]}"; do
    echo "$req (${REQ_ARR[$req]})"
  done
}

# Install any missing packages
function pkg_install() {
  [[ -n "${REQ_ARR[*]}" ]] || {
    sudo apt-get install --no-upgrade "${REQ_ARR[@]}"
  }
}

function pkg_is_installed() {
  return "$(dpkg-query -W -f '${Status}\n' "${1}" 2>&1 |
    awk '/ok installed/{print 0;exit}{print 1}')"
}
