# Clipboard

# Put a path directly in the X clipboard
pclip() { realpath "$1" | tr -d '\n' | xclip -se c; }

# Copy a path to the clipboard
pclip() { realpath "$1" | tr -d '\n' | xclip -se c; }
# Copy a string to the clipboard
eclip() { echo "$@" | xclip -se c; }

# Copy stdin to clipboard, removing final newline
alias clip="perl -pe 'chomp if eof' | xclip -se c"
# Write clipboard to stdout
alias oclip='xclip -o'
