# bashrc.d

## Install

This procedure is tested on Linux Mint 20. It should also work on any recent Ubuntu or other Debian based distribution.

The install script can be examined with:

```shell

```

### Full

See `Shared` below for a version that does not modify any existing files.

```bash
$ curl github.com:rogerdahl/bashrc/install | bash
```

The install uses `git clone` to create a copy of this repository in `~/bin/bashrc.d`, creating the directories as needed.

It then moves the original `~/.bashrc` to `~/bin/bashrc.d/_bashrc.original` and replaces it with a call to `~/bin/bashrc.d/bashrc`.

You should then move any custom goodies from your `~/.bashrc` (now at `~/bin/bashrc.d/_bashrc.original`) into `DD-name.sh` files (where `DD` is a two-digit number). `DD` range from `90` to `99` has been left open for this purpose.


### Shared (for shared accounts)

- This is the same as `Full`, except that it does not not modify `~/.bashrc` (or any other login scripts), and so does not alias any existing commands or otherwise change the look, feel or behavior of the account.

- After logging in, activate `bashrc.d` with `. ~/bin/bashrc.d/bashrc`. This can be added as a quick alias by adding `alias rcd='. ~/bin/bashrc.d/bashrc'` to the end of `~/.bashrc.d`.


- To get `bashrc.d` into the shell, 

- To 


This intended for use in shared accounts. It doesn't modify the original `~/.bashrc`

```shell script
$ bash -c '
  set -x
  BASHRC_DIR="$HOME/bin/bashrc.d2"
  mkdir -p "$BASHRC_DIR"
  git clone "git@github.com:rogerdahl/bashrc.git" "$BASHRC_DIR"
  echo >> "$HOME/.bashrc" "export BASHRC_DIR=\"\$HOME/$BASHRC_REL_DIR\""
  echo >> "$HOME/.bashrc" ". \"\$HOME/$BASHRC_REL_DIR/init.sh\""
  mv "$HOME"/.bashrc "$"
  exec bash
'
```

## Helpful hints

- `bash` has a cheat sheet! Just type `help` at the `bash` prompt.




# Custom locale

The default sort order (collation) is horrendous under Unix. It may be ok for some casual users, but it's just a mess for devs. It ignores many characters, such as `.` and `_`. In addition, it mixes small and capital letters. The result is all of these are sorted together: `_a`, `.a`, ` a`, `_A`, `.A`, ` A`

The default date format (at least in the `en_US.utf8` locale) is not good for devs either, as they jumble up the order of least to most significant values, and sorting them alphabetically does not cause them to be sorted chronologically.

This generates a custom locale that:

- Does not mix capitalized and non-capitalized letters, which is especially helpful on filenames.
- Does not ignore any leading characters, which allows dot-files to be sorted separately from other files, and makes it possible to use prefixes such as "_" to force the sort order, e.g., to show important files on top of the list.
- Has an ISO 8601-like date format: %Y-%m-%d %H:%M:%S




