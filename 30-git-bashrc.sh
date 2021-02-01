# Shortcuts for dealing with .bashrc itself.

bashrc_cd() {
  cd "$BASHRC_DIR" || {
    echo "Error: It doesn't look like we're in a bashrc.d environment (missing \$BASHRC_DIR)"
    return 1
  }
}

# git add all numbered bashrc.d scripts and push
# Using a subshell, so the interactive CWD does not change.
bashrc_push() (
  bashrc_cd || return 1
  # The regex glob must not be quoted.
  git add +\([0-9][0-9]-*.sh\)
  git commit -a -m 'Initial work'
  git push
)

tt() {
  echo +([0-9][0-9]-*.sh)
}


## git pull bashrc.d
## Using a subshell, so the interactive CWD does not change.
#bashrc_pull() (
#  bashrc_cd || return 1
#  git push
#)
#
