# bashrc.d

## Install

This procedure is tested on Linux Mint 20. It should also work on any recent Ubuntu or
other Debian based distribution.

### Full

See `Shared` below for a version that does not modify any existing files.

```bash
$ curl github.com:rogerdahl/bashrc/install | bash
```

The install uses `git clone` to create a copy of this repository in `~/bin/bashrc.d`,
creating the directories as needed.

It then moves the original `~/.bashrc` to `~/bin/bashrc.d/_bashrc.original` and replaces
it with a call to `~/bin/bashrc.d/bashrc`.

You should then move any custom goodies from your `~/.bashrc` (now
at `~/bin/bashrc.d/_bashrc.original`) into `DD-name.sh` files (where `DD` is a two-digit
number). `DD` range from `90` to `99` has been left open for this purpose.

### Shared (for shared accounts)

- This is the same as `Full`, except that it does not modify `~/.bashrc` (or any other
  login scripts), and so does not alias any existing commands or otherwise change the
  look, feel or behavior of the account.

- After logging in, activate `bashrc.d` with `. ~/bin/bashrc.d/bashrc`. This can be
  added as a quick alias by adding `alias rcd='. ~/bin/bashrc.d/bashrc'` to the end
  of `~/.bashrc.d`.

## Resources

- bash has a cheat sheet! Just type `help` at the bash prompt.

- https://devhints.io/bash

## Notes

- `bashrc.d` is only active in interactive shell sessions. However, it adds and modifies
  exported environment variables, so it may influence the behavior of programs and
  scripts started from the interactive shell.

- When writing new scripts that are intended to work outside of a `bashrc.d`
  environment, make sure you don't introduce any dependencies on the `bashrc.d`
  environment.

# Overview

* When an interactive bash shell is opened, the shell scripts on
  form `<digit><digit>-<name>.sh` are sourced in ascending numerical order. All other
  scripts and files are only used if they are referenced by one of the numbered scripts.

  All the numbered scripts are sourced in the same environment, so the results from
  scripts that have been sourced become available to the scripts yet to be sourced. So
  each script can depend on all scripts with lower numbers, but must not depend on any
  scripts with the same or higher numbers.

  When the process is completed, the interactive environment represents the final
  result.

* In addition to describing the order in which the scripts are sourced, the leading two
  digits also describe categories, as follows:

- `00 - 09` - Reserved for local use
- `10 - 19` - Basic settings and utilities useful in both interactive shell and scripts
- `30 - 39` - Set up development and build environments
- `60 - 69` - Shortcuts and convenience commands for working in the shell
- `80 - 89` - GUI related scripting / automation
- `90 - 99` - Reserved for local use

# Features

Features of the interactive environment set up by .bashrc.d.

TODO
