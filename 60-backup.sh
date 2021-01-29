# Backups

requires 'pixz' 'parallel xz'

# Create a backup of a directory tree or single file.
# This is just a convenience wrapper around tar and pixz. The backup file is stored in
# the same dir as the item being backed up.
bak() {
    [[ $# -eq 1 ]] || { echo "Usage: $1 <root dir or single file to backup>"; return 1; }
    src="${1}";
    [[ -e ${src} ]]   || { echo "Source does not exist: ${src}"; return 1; };
    dst="$(basename "${src}")-bak-$(date '+%Y-%m-%d_%H;%M').txz";
    [[ ! -e ${dst} ]] || { echo "Backup already exists: ${dst}"; return 1; };
    echo "Creating backup: ${src} -> ${dst}";
    tar --use-compress-program=pixz -cf "${dst}" "${src}";
}

