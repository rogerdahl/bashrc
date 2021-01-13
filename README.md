# bashrc.d

```shell script
$ bash -c '
  set -x
  BASHRC_REL_DIR="bin/bashrc.d"
  BASHRC_DIR="$HOME/$BASHRC_REL_DIR"
  mkdir -p "$BASHRC_DIR"
  git clone '\''git@github.com:rogerdahl/bashrc.git'\'' "$BASHRC_DIR"
  echo >> "$HOME/.bashrc" "export BASHRC_DIR=\"\$HOME/$BASHRC_REL_DIR\""
  echo >> "$HOME/.bashrc" ". \"\$HOME/$BASHRC_REL_DIR/init.sh\""
'
```

