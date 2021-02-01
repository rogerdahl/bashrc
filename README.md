
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


## Helpful hints

- bash has a cheat sheet! Just type `help` at the bash prompt.

- `bashrc.d` is only active in interactive shell sessions. However, it adds and modifies exported environment variables, so it may influence the behavior of programs and scripts started from the interactive shell.

- When writing new scripts that are intended to work outside of a `bashrc.d` environment, make sure you don't introduce any dependencies on the `bashrc.d` environment.

# Overview

* When an interactive bash shell is opened, the shell scripts on form `<digit><digit>-<name>.sh` are sourced in ascending numerical order. All other scripts and files are only used if they are referenced by one of the numbered scripts.
 
  All the numbered scripts are sourced in the same environment, so the results from scripts that have been sourced become available to the scripts yet to be sourced. So each script can depend on all scripts with lower numbers, but must not depend on any scripts with the same or higher numbers.
  
  When the process is completed, the interactive environment represents the final result.

* In addition to describing the order in which the scripts are sourced, the leading two digits also describe categories, as follows:

- `00 - 09` - Settings and basic utils
- `30 - 39` - Set up development and build environments
- `60 - 69` - Shortcuts and convenience commands for working in the shell
- `80 - 89` - GUI related scripting / automation
- `90 - 99` - Reserved for local setup tasks

# Features

Features of the interactive environment set up by .bashrc.d.

## Keyboard mapping

Starting with what's probably controversial, the minus (`-`) and underscore (`_`) keys have been switched on the keyboard. There's probably no surer way to annoy a software developer than to make a change that clashes with their muscle memory, but this one is worth it. Just consider your source code and compare the number of times the underscore is used vs. the times the minus is used.

If you really can't stand it, or you write mostly in some odd language that has lots of `-` characters, like CSS (yes, it's a language, just not a programming language), then disable the mapping `60-keyboard.sh`.  


## Custom locale

The default sort order (collation) is horrendous under Unix. It may be ok for some casual users, but it's just a mess for devs. It ignores many characters, such as `.` and `_`. In addition, it mixes small and capital letters. The result is all of these are sorted together: `_a`, `.a`, ` a`, `_A`, `.A`, ` A`

The default date format (at least in the `en_US.utf8` locale) is not good for devs either, as they jumble up the order of least to most significant values, and sorting them alphabetically does not cause them to be sorted chronologically.

This generates a custom locale that:

- Does not mix capitalized and non-capitalized letters, which is especially helpful on filenames.
- Does not ignore any leading characters, which allows dot-files to be sorted separately from other files, and makes it possible to use prefixes such as "_" to force the sort order, e.g., to show important files on top of the list.
- Has an ISO 8601-like date format: %Y-%m-%d %H:%M:%S

