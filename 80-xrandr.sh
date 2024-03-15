monitor_off() {
  run_xrandr --off
}
monitor_on() {
  run_xrandr --auto
}

run_xrandr() {
  # shellcheck disable=SC2046
  xrandr $(printf -- '--output %s ' $(get_xrandr_outputs)) "$@"
}

# Get array of connected monitors
get_xrandr_outputs() {
  rx="^([^ ]*) connected"
  xrandr -q | while IFS= read -r -d $'\n' line; do
    [[ "$line" =~ $rx ]] && printf '%s ' "${BASH_REMATCH[1]}"
  done
}
