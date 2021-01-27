# Magic that causes output to stderr to be colored red

stderr_red="$BASHRC_DIR/libstderred.so"
[[ -f "$stderr_red" ]] && {
  export LD_PRELOAD="$stderr_red${LD_PRELOAD:+:$LD_PRELOAD}"
}
# || {
#  printf '\nlibstderred.so no found\n'
#}
# Aliases to turn stderr coloring on and off (it's on by default)
alias red-off='LD_PRELOAD_RED_OFF=$LD_PRELOAD; unset LD_PRELOAD'
alias red-on='LD_PRELOAD=$LD_PRELOAD_RED_OFF; unset LD_PRELOAD_RED_OFF'

# Check if stderred works. Prints a line of text to stderr, which should show up in red.
function check-stderred() {
  python <<EOF
import sys;
print("This line is written to stderr and should be colored red", file=sys.stderr);
EOF
}
