# Pretty printing and syntax highlighting

# When using `bat` for syntax highlighting, I'm using `--language python` for some types
# for which `bat` has specific syntax highlighting available. I've tried those and found
# that highlighting as Python gives overall better results. What happens is that the
# specific highlighter will be semantically correct, for instance uniformly highlighting
# all string literals in a single color, while the Python highlighter thinks it's seeing
# operators and keywords in the strings, and highlights them as such. And it turns out
# that those are often significant to the human viewer, who knows what the information
# stored in the strings is.


# --sample-tidy --full-trace
# keep running. can't be combined with --sample-ask as pytest suppresses prompts. can be combined with --sample-write

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
g() { grep -i -r --color=always -C 10 "$1" . | less -R; }

# CSV (column + bat)
pcsv() {
  require 'util-linux' # column
  require 'bat'

  column -t -s, -n "$1" |
    bat --wrap never --language python --pager \
      "less --no-init --quit-if-one-screen --chop-long-lines --quit-on-intr --RAW-CONTROL-CHARS"
}

# GNU Source-highlight
require source-highlight
LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
padd '-R' ' '
export LESSOPEN LESS

