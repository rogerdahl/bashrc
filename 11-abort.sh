# Abort script regardless of if its's executed, sourced or a function

# This adds a snippet that checks the return code for all functions and, if it's the
# magic one, aborts the script.


#set -o functrace > /dev/null 2>&1
#shopt -s extdebug

# force inheritance of ERR trap inside functions and subshells
shopt -s extdebug

# pick custom error code to force script end
#custom_error_code=133

# clear ERR trap and set a new one
#trap 'echo "TEST"; [[ $? == "$custom_error_code" ]] && echo "IN TRAP" && return $custom_error_code 2>/dev/null;' ERR
#trap - INT
#trap 'echo "TEST"; ' INT

abort() {
  b=$(ps --no-headers --format args --pid "$BASHPID")
  echo "$b"
#  exec $(ps --no-headers --format args --pid "$BASHPID")
}

#trap - INT
#trap 'printf "Aborting..." >&2; exec bash' INT


#  printf "Aborting..." >&2
##  return "$custom_error_code"
#  kill -s INT $BASHPID

## clear traps
#trap - ERR
## disable inheritance of ERR trap inside functions and subshells
shopt -u extdebug


#trap "exit 1" SIGINT
#export TOP_PID=$$
#echo "$TOP_PID"
#
#abort() {
#  printf >&2 "Aborting..."
##  echo "$BASHPID"
##
##  [[ $$ == $BASHPID ]] && {
##
##  }
#  kill -s SIGINT $BASHPID
#}
