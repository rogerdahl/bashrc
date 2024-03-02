# X settings

# Default settings for X11 apps are in /usr/share/X11/app-defaults/

# Activate settings in ~/.Xresources
x-merge() {
  [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
}

# List X settings
x-settings() {
  xrdb -query -all
}

x-merge

