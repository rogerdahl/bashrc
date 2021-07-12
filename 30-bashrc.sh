# Commands for working with bashrc.c itself

# Open a bashrc.d/*.sh file for editing
alias rcvim='vim "$BASHRC_DIR"'

rccd() {
  wd="$(pwd)"
  pushd "$BASHRC_DIR"
  printf 'popd will return to: %s\n' "$wd"
}

