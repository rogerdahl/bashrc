# Terminal

# https://stackoverflow.com/a/52944692/442006

# Bash syntax:
#
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

# Get current position of the caret. Correctly ignores ANSI color codes and other
# control characters that don't move the cursor.
#
# Note: To use this inside of a loop that also uses `read`, use read -u 9 in the outer
# (calling) loop. See safe-find.sh:
# https://github.com/l0b0/tilde/blob/master/examples/safe-find.sh
#
# Get current column position of the caret.
# shellcheck disable=SC2046,SC2086
get_caret_col() {
  IFS=' ' set $(get_caret_pos)
  printf '%s' ${*:1:1}
}

# Get current row position of the caret.
# shellcheck disable=SC2046,SC2086
get_caret_row() {
  IFS=' ' set $(get_caret_pos)
  printf '%s' ${*:2:1}
}

# Get current column and positions of the caret on format: "col pos".
get_caret_pos() {
  local pos
  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
  printf '%s %s' "${pos[2]}" "${pos[1]}"
}


#----------------------------------------------------------------------
# print ten lines of random widths then fetch the cursor position
#----------------------------------------------------------------------
#

test_caret_pos() {
  MAX=$(( $(tput cols) - 15 ))
  for _ in {1..10}; do
    cols=$(( $RANDOM % $MAX ))
    printf "%${cols}s"  | tr " " "="
    echo " $(get_caret_pos)"
  done
}
