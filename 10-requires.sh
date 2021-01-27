# Simple system to discover and install dependencies of the various bashrc.d modules.

# Create an associative array (dict). We use the key for package name and value for
# comments, such as what's needed from the package.
declare -A REQ_ARR
export REQ_ARR

# Add an apt package to the list of deps
function requires() {
  pkg="$1"
  comment="$2"
  # shellcheck disable=SC2030
  echo "Requires: ${pkg}$([[ -n "$comment" ]] && echo -n " ($comment)"; )"
  # shellcheck disable=SC2031
  REQ_ARR["$pkg"]="$comment"
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
