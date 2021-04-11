# sudo

# List of commands that require root
# - Aliases that "sudo" will be added automatically
# - On most Linux distributions, this will trigger a password prompt.
# - Commands that don't exist in the the current path are ignored.
# - Adding a trailing space to the command causes the next word to be checked for
# alias substitution when the alias is expanded.
declare -a SUDO_COMMANDS=(
  poweroff
  reboot
  apt
  apt-get
  iotop
  systemctl
  journalctl
  nvidia-settings
)

# Generate aliases that prepend "sudo" to commands that require root.
add_sudo() {
  for cmd in "${SUDO_COMMANDS[@]}"; do
    #printf "%s\n" "$cmd"
    # shellcheck disable=SC2139
    # shellcheck disable=SC2140
    cmd_is_installed "$cmd" && alias "$cmd"="sudo $cmd"
  done
}

add_sudo
