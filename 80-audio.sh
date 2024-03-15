# Delete all user specific pulse audio config
pulse_clear() {
  rm -r ~/.pulse ~/.pulse-cookie ~/.config/pulse
}

# Kill and restart
pulse_restart() {
  pulseaudio -k
  pulseaudio --start
}

# Kill and restart 2
pulse_restart2() {
  systemctl --user stop pulseaudio.socket
  systemctl --user stop pulseaudio.service
  pulseaudio -v
}

