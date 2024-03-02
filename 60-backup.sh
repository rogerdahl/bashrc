# Backups

require 'zstdmt' # parallel zstd

# Create a backup of a directory tree or single file.
# This is just a convenience wrapper around tar and zstd.
# The backup file is stored in the same dir as the item being backed up.
bak() {
  [[ $# -eq 1 ]] || {
    printf 'Usage: %s <root dir or single file to backup>\n' "$0"
    return 1
  }
  src="${1}"
  [[ -e ${src} ]] || {
    printf 'Source does not exist: %s\n' "${src}"
    return 1
  }
  dst="$(basename "${src}")-bak-$(nowfn).tar.zstd"
  [[ ! -e ${dst} ]] || {
    printf 'Backup already exists: %s\n' "${dst}"
    return 1
  }
  printf 'Creating backup: %s -> %s\n' "${src}" "${dst}"
  tar --use-compress-program='zstdmt -T16' -cf "${dst}" "${src}"
}
