# bashrc.d

## Install

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

* The existing ~/.bashrc file is moved into ~/bin/bashrc.d/bashrc.original

##

# Custom locale

The default sort order (collation) is horrendous under Unix. It may be ok for some casual users, but it's just a mess for devs. It ignores many characters, such as `.` and `_`. In addition, it mixes small and capital letters. The result is all of these are sorted together: `_a`, `.a`, ` a`, `_A`, `.A`, ` A`

The default date format (at least in the `en_US.utf8` locale) is not good for devs either, as they jumble up the order of least to most significant values, and sorting them alphabetically does not cause them to be sorted chronologically.

This generates a custom locale that:

- Does not mix capitalized and non-capitalized letters, which is especially helpful on filenames.
- Does not ignore any leading characters, which allows dot-files to be sorted separately from other files, and makes it possible to use prefixes such as "_" to force the sort order, e.g., to show important files on top of the list.
- Has an ISO 8601-like date format: %Y-%m-%d %H:%M:%S

