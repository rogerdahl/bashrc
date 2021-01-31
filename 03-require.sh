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
    pkg-is_installed "$pkg"
    [[ $? -ne 0 ]] && {
      echo "Missing package: $pkg"
      missing=1
    }
  done
  return $missing
}

# Add an apt package to the list of deps
#require() {
#  pkg="$1"
#  comment="$2"
#  # shellcheck disable=SC2030
#  echo "require: ${pkg}$([[ -n "$comment" ]] && echo -n " ($comment)"; )"
#  # shellcheck disable=SC2031
#  REQ_ARR["$pkg"]="$comment"
#}

list_deps() {
  for pkg in "${!REQ_ARR[@]}"; do
    echo "$pkg (${REQ_ARR[$pkg]})"
  done
}

# Install any missing packages
pkg_install() {
  [[ -n "${REQ_ARR[*]}" ]] || {
    sudo apt_get install --no-upgrade "${REQ_ARR[@]}"
  }
}

# Exit with status 0 (exists) or 1 (does not exist) for a given package name.
pkg-is_installed() {
#  return "$(dpkg-query -W -f '${Status}\n' "${1}" 2>&1 |
#    awk '/ok installed/{print 0;exit}{print 1}')"
  q="$(dpkg-query -W -f '${Status}\n' "${1}" 2>&1)"
  [[ "$q" =~ is\ installed ]] && return 1
  return 0
}
