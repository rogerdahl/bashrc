#!/usr/bin/env bash

# This is the initial installer, launched by downloading and piping it to bash.
#
# $ curl github.com:rogerdahl/bashrc/install | bash

# Stop on error.
set -x

echo "Check for and install Git if needed"
sudo apt update
sudo sudo apt-get install --yes --no-upgrade git

BASHRC_DIR="$HOME/bin/bashrc.d"
mkdir -p "$BASHRC_DIR"

echo "Cloning bashrc.d into $BASHRC_DIR..."
git clone "git@github.com:rogerdahl/bashrc.git" "$BASHRC_DIR"

OLD_BASHRC="$BASHRC_DIR/bashrc.orig"
echo "Moving original ~/.bashrc -> $OLD_BASHRC"
mv "$HOME/.bashrc" "$OLD_BASHRC"

echo "Writing stub ~/.bashrc that sources bashrc.d/init.sh"
echo > "$HOME/.bashrc" ". $BASHRC_DIR/init.sh"

read -p 'Hit enter to launch a new shell and run initial automatic setup'
exec bash
