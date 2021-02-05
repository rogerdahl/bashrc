# Utilities that have dependencies that may not be available.

require 'util-linux' # /bin/findmnt

# str or device
is_mounted() { findmnt -rno src,TARGET "$1" >/dev/null; }
