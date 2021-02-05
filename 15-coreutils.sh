# The coreutils package "contains the basic file, shell and text manipulation utilities
# which are expected to exist on every operating system."
#
# These are generally useful as well, and they remain available in the interactive
# shell.

require 'coreutils' # realpath

# Exit the script with warning if it was not sourced. Also turn off any executable
# permissions on the script file.
assert_is_sourced() {
	is_sourced || {
		error "This script must be sourced: . $0"
		chmod a-x "$0"
		# `exit` in a sourced script causes the user's interactive shell to be closed, but
		# we can safely use it here since we now know we are not sourced.
		exit
	}
}

# Add path to the front of PATH, or another ":" delimited env var.
# - Converts relative path to absolute.
# - No-op if the path does not exist.
# - Uses current dir if path not given.
# - Optional second argument allows acting on another env var.
padd() {
	#  (( "$#" < 1 | "$#" > 2)) && {
	#    # shellcheck disable=SC2016
	#    echo "Usage: $0 <string to add> <delimiter> <env var name (no \$)>"
	#    return 1
	#  }

	# shellcheck disable=SC2034
	__in=("$@")
	# shellcheck disable=SC2034
	__args=('string to add' 'delimiter' 'env var name (no \$)')
	usage __in __args && return 1

	path="$1"
	if [[ -n "$2" ]]; then env_var="$2"; else env_var="PATH"; fi
	# realpath is in coreutils.
	abs_path="$(realpath --canonicalize-existing --quiet "$path")"
	if [ $? -eq 0 ]; then
		add_str "$env_var" "$abs_path" ':'
	else
		dbg "Ignored non-existing path: $path"
	fi
}
