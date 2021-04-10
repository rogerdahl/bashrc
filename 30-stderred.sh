# stderr in red
#
# git://github.com/sickill/stderred.git
#
# This is some deep magic that causes the output to stderr to be colored red. It has
# some tickets on GitHub (~30 or so), but I've never had any trouble with it.

require 'build-essential' 'cmake'

red_root="$BASHRC_DIR/stderred"
red_so="$red_root/build/libstderred.so"
red_disabled="$red_root/DISABLED"

# Check if stderred works. Prints a line of text to stderr, which should show up in red.
red_test() {
  python3 <<EOF
import sys;
print("This line is written to stderr and should be colored red", file=sys.stderr);
EOF
}

red_clean() {
  rm -rf "$red_root/DISABLED"
  rm -rf "$red_root/build/"
  unset LD_PRELOAD
}

red_is_compiled() {
  [[ -f "$red_so" ]] && return 0 || return 1
}

red_build() {
  red_clean

  cd "$red_root" || {
    error 'The path to the stderred source is invalid'
    return 1
  }

  make -j8

  red_is_compiled || {
    touch "$red_disabled"
    error "Unable to build 'stderred' (stderr in red). "
    error "stderr output will not be colored."
    error "To retry, type 'red_build'"
  }
}

# Exit silently if stderred has been disabled or a previous compile failed.
is_file "$red_disabled" && {
  dbg "Skipping 'stderred' (disabled). To retry, type 'red_build'"
  return 0
}

red_is_compiled || {
  red_build
  red_test
}

padd "$red_so" ':' 'LD_PRELOAD'

# Aliases to turn stderr coloring on and off (it's on by default).
alias red-off='LD_PRELOAD_RED_OFF=$LD_PRELOAD; unset LD_PRELOAD'
alias red-on='LD_PRELOAD=$LD_PRELOAD_RED_OFF; unset LD_PRELOAD_RED_OFF'
