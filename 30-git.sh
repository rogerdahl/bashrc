# Git

# Alias

alias git_s="git status"
alias git_d="git difftool -y"
alias git_b="git branch"
alias git_c="git checkout"
alias git_dhi="git difftool -y --cached"
alias git_diw="git difftool -y"
alias git_dhw="git difftool -y HEAD"
# For initial, informal work.
alias git_i="git commit -a -m 'initial work' && git push"
alias git_unstage_all='git reset'

# Generate changelog.md base from git log
git_changelog() { git log --format="%n* %s%n    * %b" $1 >>CHANGELOG.md; }

# DataONE
alias gfix="git add /home/dahl/dev/d1_python/test_utilities/src/d1_test/test_docs && git commit -a -m 'Fix build' && git push"
