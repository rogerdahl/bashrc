# Search path

# Set PATH to system default
path_reset() {
  PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin'
}

padd "$HOME/bin"
padd "$HOME/local/bin"
padd "$HOME/bin-local"
padd "$HOME/bin/sym"

