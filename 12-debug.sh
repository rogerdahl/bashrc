## Debugging.
#
## Print stack trace and pause
#trace_and_wait() {
##  sep="$(repeat_str 30 '=')"
##  printf '%s ERROR TRAP %s\n' "$sep" "$sep"
#  sep 'ERROR TRAP'
#  stacktrace 2
#  printf '&&&&&&&&&&& AFTER STACKTRACE\n'
#  repeat_str 30 $'\n'
##  echo 2>&1 "\n"
#  echo 'ECHO Hit Enter\n\\n\n'
##  read  -rp 'Hit Enter' 2>&1
##  read
#  echo 'AFTER ECHO Hit Enter\n\\n\n'
#}
#
#
#
##print_and_wait() {
##  # shellcheck disable=SC2059
##  printf "$@"
##  printf
##  read -p 'Hit Enter... (PRINT_AND)\n'
##}
#
## Dump stack trace.
#stacktrace() {
#  printf '############### STACKTRACE BEGIN\n'
#  local frame_skip="$1"
#  printf '%s\n' "$frame_skip"
#  local frame_count=${#FUNCNAME[@]}
#
#  # Alternate from another function:
#  # while caller $i | read line func file; do
#  # echo >&2 "[$i] $file:$line $func(): $(sed -n ${line}p $file)"
#  # ${BASH_COMMAND}
#  n=$((frame_count - frame_skip - 1))
#  printf '%s' "$n"
#  for ((i = frame_count - frame_skip - 1; i >= 0; i--)); do
#    local func="${FUNCNAME[$i]}"
#    local line="${BASH_LINENO[$i]}"
#    local src="${BASH_SOURCE[$i]}"
#    printf "|%*s %s() %s:%s\n" $((2 * (frame_count - i - 1))) '' "$func" "$src" "$line"
#
#    #    caller $i | {
#    #      read -r line func src
#    #      printf "|%*s %s() %s:%s\n" $((2 * (frame_count - i - 1))) '' "$func" "$src" "$line"
#    #    }
#  done
##  printf '############### STACKTRACE END\n'
#}
#
#trace_top_caller() {
#  local func="${FUNCNAME[1]}"
#  local line="${BASH_LINENO[0]}"
#  local src="${BASH_SOURCE[0]}"
#  echo "  called from: $func(), $src, line $line"
#}
#
#set -o errtrace
#trap 'trace_and_wait' ERR
