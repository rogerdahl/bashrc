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

# Add an apt package to the list of deps
#requires() {
#  pkg="$1"
#  comment="$2"
#  # shellcheck disable=SC2030
#  echo "Requires: ${pkg}$([[ -n "$comment" ]] && echo -n " ($comment)"; )"
#  # shellcheck disable=SC2031
#  REQ_ARR["$pkg"]="$comment"
#}

list-deps() {
  for pkg in "${!REQ_ARR[@]}"; do
    echo "$pkg (${REQ_ARR[$pkg]})"
  done
}

# Install any missing packages
pkg-install() {
  [[ -n "${REQ_ARR[*]}" ]] || {
    sudo apt-get install --no-upgrade "${REQ_ARR[@]}"
  }
}

pkg-is-installed() {
  return "$(dpkg-query -W -f '${Status}\n' "${1}" 2>&1 |
    awk '/ok installed/{print 0;exit}{print 1}')"
}

