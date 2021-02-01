# Git completion

# When working, "git<tab><tab>" on the command line will show a list of git commands.
# Switches are also completed. "git diff --<tab><tab>".

git_root="$BASHRC_DIR/git"
git_completion="$git_root/git-completion.bash"
git_prompt="$git_root/git-prompt.sh"
git_completion_url='https://raw.githubusercontent.com/git/git/master/contrib/completion'

git_setup() {
  clear_disabled 'git'

  pkg_install git meld curl
  # Use `meld` for merges.
  git config --global merge.tool meld
  # Stop git merges from creating .orig files.
  git config --global mergetool.keepBackup false

  mkdir -p "$git_root"

  curl -o "$git_prompt" "$git_completion_url/git-prompt.sh"
  curl -o "$git_completion" "$git_completion_url/git-completion.bash"
}

is_ready() {
  is_file "$git_completion" && is_file "$git_prompt"
  return $?
}

is_flag 'git' 'disabled' && return

is_ready || {
  git_setup
  is_ready || return
}

# shellcheck disable=SC1090
. "$git_completion"
# shellcheck disable=SC1090
. "$git_prompt"

# shellcheck disable=SC2016
add_str "\$(__git_ps1)" ' ' 'PS1'
