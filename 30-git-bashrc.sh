# Shortcuts for dealing with .bashrc itself.

rc_cd() {
  cd "$BASHRC_DIR" || {
    echo "Error: It doesn't look like we're in a bashrc.d environment (missing \$BASHRC_DIR)"
    return 1
  }
}

# git add all numbered bashrc.d scripts and push
# Using a subshell, so the interactive CWD does not change.
#
# The regex in this function somehow breaks implicit exports with "set -a" ?

rc_push() {
  rc_cd || return 1
  # The extglob (regex glob) must not be quoted.
  # This will return an error if `shopt -s extglob` has not been set.
  git add +([0-9][0-9]-*.sh)
  git commit -a -m 'Initial work'
  git push
}

# git pull bashrc.d
# Using a subshell, so the interactive CWD does not change.
rc_pull() (
  rc_cd || return 1
  git pull
)

# Launch a new shell, replacing current.
rc() {
  exec bash
}
