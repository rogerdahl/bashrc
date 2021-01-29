# stderr in red
#
# git://github.com/sickill/stderred.git
#
# This is some deep magic that causes the output to stderr to be colored red. There are
# some tickets on GitHub (~30 or so), but I've never had any trouble with it.

red_root="$BASHRC_DIR/stderred"
red_so="$red_root/build/libstderred.so"
red_disabled="$red_root/DISABLED"

new_build="0"

# Check if stderred works. Prints a line of text to stderr, which should show up in red.
check-stderred() {
  python <<EOF
import sys;
print("This line is written to stderr and should be colored red", file=sys.stderr);
EOF
}

# Exit silently if stderred has been disabled or compile failed.
# To retry the build, remove the 'stderred/DISABLED' file and reload.
[[ -e "$red_disabled" ]] && return 0

[[ ! -f "$red_so" ]] && (
  new_build="1"
  build_error="0"

  if [[ ($(require 'build-essential' 'cmake')) ]]; then
    build_error="1"
  else
    cd "$red_root"
    make -j8
    [[ -f "$red_so" ]] || build_error="1"
  fi

  [[ "$build_error" == "1" ]] && {
    touch "$red_disabled"
    error "Unable to build 'stderred' (stderr in red). "
    error "stderr output will not be colored."
    error "To retry the build, install any missing dependencies, remove"
    error "the \"${red_disabled}\" file, and reload."
    return 1
  }

  check-stderred
)

padd "$red_so" 'LD_PRELOAD'

# Aliases to turn stderr coloring on and off (it's on by default)
alias red-off='LD_PRELOAD_RED_OFF=$LD_PRELOAD; unset LD_PRELOAD'
alias red-on='LD_PRELOAD=$LD_PRELOAD_RED_OFF; unset LD_PRELOAD_RED_OFF'
