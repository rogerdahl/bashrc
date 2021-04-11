# Terminal

#!/usr/bin/env bash
#
# curpos -- demonstrate a method for fetching the cursor position in bash
#           modified version of https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
#
#========================================================================================
#-
#-  THE METHOD
#-
#-  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
#-
#-  THE BREAKDOWN
#-
#-  $'\e[6n'                  # escape code, {ESC}[6n;
#-
#-    This is the escape code that queries the cursor postion. see XTerm Control Sequences (1)
#-
#-    same as:
#-    $ echo -en '\033[6n'
#-    $ 6;1R                  # '^[[6;1R' with nonprintable characters
#-
#-  read -p $'\e[6n'          # read [-p prompt]
#-
#-    Passes the escape code via the prompt flag on the read command.
#-
#-  IFS='[;'                  # characters used as word delimiter by read
#-
#-    '^[[6;1R' is split into array ( '^[' '6' '1' )
#-    Note: the first element is a nonprintable character
#-
#-  -d R                      # [-d delim]
#-
#-    Tell read to stop at the R character instead of the default newline.
#-    See also help read.
#-
#-  -a pos                    # [-a array]
#-
#-    Store the results in an array named pos.
#-    Alternately you can specify variable names with positions: <NONPRINTALBE> <ROW> <COL> <NONPRINTALBE>
#-    Or leave it blank to have all results stored in the string REPLY
#-
#- -rs                        # raw, silent
#-
#-    -r raw input, disable backslash escape
#-    -s silent mode
#-
#- || echo "failed with error: $? ; ${pos[*]}"
#-
#-     error handling
#-
#-  ---
#-  (1) XTerm Control Sequences
#-      http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Functions-using-CSI-_-ordered-by-the-final-character_s_
#========================================================================================
#-
#- CAVEATS
#-
#- - if this is run inside of a loop also using read, it may cause trouble.
#-   to avoid this, use read -u 9 in your while loop. See safe-find.sh (*)
#-
#-
#-  ---
#-  (2) safe-find.sh by l0b0
#-      https://github.com/l0b0/tilde/blob/master/examples/safe-find.sh
#=========================================================================================


#================================================================
# fetch_cursor_position: returns the users cursor position
#                        at the time the function was called
# output "<row>:<col>"
#================================================================
get_caret_col() {
  local pos
  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
  echo "${pos[2]}"
}

get_caret_row() {
  local pos
  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
  echo "${pos[1]}"
}

get_caret_pos() {
  local pos
  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
  echo "${pos[2]}:${pos[1]}"
}


#----------------------------------------------------------------------
# print ten lines of random widths then fetch the cursor position
#----------------------------------------------------------------------
#

test_cursor_position() {
  MAX=$(( $(tput cols) - 15 ))

  for _ in {1..10}; do
    cols=$(( $RANDOM % $MAX ))
    printf "%${cols}s"  | tr " " "="
    echo " $(fetch_cursor_position)"
  done
}
