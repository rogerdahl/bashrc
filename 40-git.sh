# Git

alias gs="git status"
alias gd="git difftool -y"
alias gb="git branch"
alias gc="git checkout"
alias gdhi="git difftool -y --cached"
alias gdiw="git difftool -y"
alias gdhw="git difftool -y HEAD"
# For initial, informal work.
alias git_i="git commit -a -m 'initial work' && git push"
alias git_unstage_all='git reset'
# Git commands for initial, informal work.
alias git_i="git commit -a -m 'Initial work' && git push"

alias gfix="git add /home/dahl/dev/d1_python/test_utilities/src/d1_test/test_docs && git commit -a -m 'Fix build' && git push"
# Generate changelog.md base from git log

#
function git_changelog() { git log --format="%n* %s%n    * %b" $1 >>CHANGELOG.md; }

function git_bashrc_push() (
  cd "$BASHRC_DIR" || exit
  git commit -a -m 'Initial work'
  git push
)

function git_bashrc_pull() (
  cd "$BASHRC_DIR" || exit
  git pull
)

alias git_show_remote='git config --get remote.origin.url'

# Dangerous!

# Merge all commits in the repository to a single commit called, "Initial work".
#
# This removes all history from the git repository. I usually don't track changes on
# initial work on a project. I use this function when a project reaches a state where I
# want to more formally start tracking changes.
#alias git_danger_squash_all_commits_to_one="git reset $\(git commit-tree HEAD^{tree} -m 'Initial work'\) && git push -f"
alias dangerous_git_squash_all_commits_to_one() {
  first_commit=$(git commit-tree HEAD^{tree} -m 'Initial work')
  git reset "$first_commit"
  # git push -f"
}
