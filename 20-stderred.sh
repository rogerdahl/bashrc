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

# Check stderr_red
# bash does not seem to load the .so. Not sure why. This will check if it works.
red='/tmp/test-stderr_red'
cat > $red.c <<EOF
#include "stdio.h"
int main() {
  fprintf(stderr, "This line is written to stderr and should be colored red\n");
  return 0;
}
EOF
gcc -o $red $red.c
$red
rm $red $red.c

