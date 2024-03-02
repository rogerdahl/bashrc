# Xpra

# https://xpra.org/trac/wiki/Usage

xrun() {
  host="$1"
  app="$2"
  xpra start "ssh://${host}/" --start-child="${app}" --opengl=yes --dpi=96 --daemon=no

}

