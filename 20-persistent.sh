# Simple key/value store for persisting values to disk.

# Bash doesn't have typed variables. They're instead interpreted based on the context in
# which they're used. It wouldn't surprise me if even stuff like associate arrays are
# stored as strings internally. Due to this, we have to resort to trickery to do basic
# stuff like this k/v store.

# Create an associative array (dict)
declare -A KV
KV_MODIFIED=false
KV_PATH="$BASHRC_DIR/kv.sh"

#kv_init() {
#  [[ -f "STORE" ]] && {
#    . STORE
#    KV_MODIFIED=false
#  }
#}

kv_restore() {
  dbg 'kv_restore()'
  [[ -f "$KV_PATH" ]] || { true > "$KV_PATH"; }
  while IFS= read -r kv; do
    dbg '%s' "$kv"
#    dbg "%s" "$kv"
#    eval "$kv"
  done < "$KV_PATH"
}

#  [[ -f "$KV_PATH" ]] && {
#    for line in "$KV_"
#  }. "$KV_PATH"
##  printf '%s' "${KV[$k]}"
#}

# Usage:
# kv_set <name of global variable to store>
# Bash can't pass complex values to functions, but can
# use nameref for indirection
kv_save() {
  printf 'kv_save()'
  #  k="$1"
  k="$1"
  v="$(declare -p "$k")"
  dbg 'k="%s" v="%s"' "$k" "$v"
  KV["$k"]="$v"
}

function kv_finish() {
#  printf 'kv_finish()'
#  printf '# Persistent vars'
  printf '%s' "${KV[@]}"

  #
  #  printf "%s" "${KV['colors']}"
  ##  local v
  #  for k in ${KV[*]}; do

  #
  #    v="${KV[k]}"
  #    printf 'k='%s' v='%s'' "$k" "$v"
  #
  ##    v= "$pkg (${KV[$pkg]})"
  #  done
} >"$KV_PATH"

trap kv_finish EXIT

#  dbg "set() '$k'='$v'"

#   local -n arr=$1
#   arr=(one "two three" four)
#   k=
#  VK[$1]="$2"

#  declare -p var1 var2 >./environ
# NOTE: no '$' before var1, var2

# Usage:
# use_array() {
#     local my_array
#     create_array my_array       # call function to populate the array
#     echo "inside use_array"
#     declare -p my_array         # test the array
# }

#use_array                       # call the main function

#function kv_finish() {
#  local v
#  for v in "${!KV[@]}"; do
#    echo "$pkg (${KV[$pkg]})"
#  done
#
#  if [ -n "$instance" ]; then
#    ec2-terminate-instances "$instance"
#  fi
#  rm -rf "$scratch"
#}
#
#trap kv_finish EXIT
#
## Check if packages are present and, if they are not, add them to a list of missing
## requirements. If all the packages in the list are present, exit with 0 (true), else 1
## (false).
#require() {
#  missing=0
#  for pkg in "$@"; do
#    pkg_is_installed "$pkg"
#    [[ $? -ne 0 ]] && {
#      echo "Missing package: $pkg"
#      missing=1
#    }
#  done
#  return $missing
#}

# Add an apt package to the list of deps
#require() {
#  pkg="$1"
#  comment="$2"
#  # shellcheck disable=SC2030
#  echo "require: ${pkg}$([[ -n "$comment" ]] && echo -n " ($comment)"; )"
#  # shellcheck disable=SC2031
#  KV["$pkg"]="$comment"
#}

#list_deps() {
#  for pkg in "${!KV[@]}"; do
#    echo "$pkg (${KV[$pkg]})"
#  done
#}
#
## Install any missing packages.
#pkg_install_missing() {
#  [[ -n "${KV[*]}" ]] || {
#    pkg_install "${KV[@]}"
#  }
#}
#
## Install a list of packages.
#pkg_install() {
#  sudo apt-get install --no-upgrade --yes "$@"
#}
#
## Exit with status 0 (exists) or 1 (does not exist) for a given package name.
#pkg_is_installed() {
#  q="$(dpkg-query -W -f '${Status}' "${1}" 2>&1)"
#  [[ "$q" =~ is\ installed ]] && return 1
#  return 0
#}
#
##scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
