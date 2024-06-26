# Pretty printing and syntax highlighting

# Primary syntax highlighter is `bat`. Fallback is `source-highlight`.

# When using `bat` for syntax highlighting, I'm using `--language python` for some types
# for which `bat` has specific syntax highlighting available. I've tried those and found
# that highlighting as Python gives overall better results. What happens is that the
# specific highlighter will be semantically correct, for instance uniformly highlighting
# all string literals in a single color, while the Python highlighter thinks it's seeing
# operators and keywords in the strings, and highlights them as such. And it turns out
# that those are often significant to the human viewer, who knows what the information
# stored in the strings is.

# Log file
pl() { black - <"$1" | bat --language python; }
alias batlog='bat --paging=never --language python'
# bat --style params: changes,grid,numbers,header,snip

# XML doc (xmlstarlet + bat)
px() { xmlstarlet format "$1" | bat --language xml; }

# Python (Black + bat)
pp() {
  black - <"$1" 2>/dev/null | bat --language python --style plain,changes,grid,numbers,snip
}

# Recursive egrep in current dir with context and color
g() { grep -i -r --color=always -C 10 "$1" .; }

# CSV (column + bat)
pcsv() {
  require 'util-linux' # column
  require 'bat'

  column -t -s, -n "$1" |
    bat --wrap never --language python --pager \
      "less --no-init --quit-if-one-screen --chop-long-lines --quit-on-intr --RAW-CONTROL-CHARS"
}

# GNU Source-highlight
# Use Bat as the primary highlighter, as it supports many more languages and understands
# much more syntax. Source-highlight is good as a fallback.
require source-highlight
if cmd_is_installed 'source-highlight'; then
  LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
  add_str 'LESS' '-R'  ' '
  export LESSOPEN LESS

  # When getting a list of the output options, it's called a language, but when selecting
  # it, it's called a format.
  alias hl-lang-list='source-highlight --lang-list | less'
  alias hl-format-list='source-highlight --outlang-list | less'
  alias hl='source-highlight --src-lang python --out-format esc256 | less -R'
fi

# Make 'less' scroll lines just before a match into view (shows context)
# and pass though ANSI color codes.
add_str 'LESS' 'j5' ' '
add_str 'LESS' '-R' ' '
# Make 'less' use the same text buffer instead of a separate one. 
# The main effect is that, on exit, the text displayed by 'less'
# remains on screen instead of being replaced with the text that
# was on screen before 'less' was launced.
add_str 'LESS' '-X' ' '

