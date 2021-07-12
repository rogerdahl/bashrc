# Misc stuff that doesn't seem to fit anywhere else

# 966  2021-03-15 21:18:1615864714  git clone https://github.com/joeyespo/grip.git
#  967  2021-03-15 21:18:1615864715  cd grip/grip
#  968  2021-03-15 21:18:1615864715  python3 __main__.py /path/to/your/README.md
#  969  2021-03-15 21:18:1615864729  python3 __main__.py /home/dahl/dev/dex/eml-utils/README.md

# Bash syntax, [ ] vs [[ ]].
# - `[[` is a bash extension that causes fewer WTFs than `[`.
# - `[` is a command, built into bash and in coreutils (usually at `/usr/bin/[`).
# - `[` and `test` is the same command

ENV_PATH="/usr/bin/env"

declare -A SHEBANG_MAP=(
  [aw]="gawk -f"
  [lu]="lua"
  [pl]="perl -w"
  [py]="python"
  [r]="Rscript"
  [R]="Rscript"
  [rb]="ruby -w"
  [sc]="csi -script"
  [sh]="bash\n\nset -euo pipefail\n"
)

exe() {
  arg=("$@") req=('path to existing or new script') opt=()
  usage arg req opt && return 1

  echo "$1"

  has_shebang "$1" || {
    add_shebang "$1"
  }

#  chmod a+x "$1"

#  "$EDITOR" "$1"
}


has_shebang() {
   read -r first_line < "$1"
   echo "$first_line"
   [[ "$first_line" =~ ^#!/ ]] && return 0
   return 1
}

add_shebang() {
  require_cmd qwerlj
  printf "going\n"

#  filename="$1"
#  ext_str="${filename#*.}"
#  [[ -d $ext_str ]] || {
#    printf 'Unable to get extension from filename: "%s"\n' "$filename"
#    return 1
#  }
#  bang_str="${SHEBANG_MAP[ext_str]}"
#  [[ -d $bang_str ]] || {
#    printf 'Unknown filename extension: "%s"\n' "$ext_str"
#  }

}
add_shebang2() {
  add_shebang
  printf "going2\n"
}
