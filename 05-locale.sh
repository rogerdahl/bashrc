# Custom locale

# Overview of locale env vars:
#
# https://tldp.org/HOWTO/Indic-Fonts-HOWTO/locale.html
#
# LANGUAGE:
#     override for LC_MESSAGES
# LC_ALL
#     override for all other LC_* variables
# LC_CTYPE, LC_MESSAGES, LC_COLLATE, LC_NUMERIC, LC_MONETARY, LC_TIME
#     individual variables for: character types and encoding, natural language messages, sorting rules, number formatting, money amount formatting, date and time display.
# LANG
#     default value for all LC_* variables. (See `man 7 locale' for a detailed description.)


# Set user LOCPATH, which overrides the system locale location.
LOCPATH="$BASHRC_DIR/locale"
export LOCALE_PATH

[[ -e "$LOCPATH/LC_ADDRESS" ]] || {
  set -x
  mkdir -p "$BASHRC_DIR/locale"
  "$BASHRC_DIR/generate-locale.py"
}

function unset_all_lc() {
  for x in $(env | grep LC); do
    unset "$(echo "$x" | perl -pe 's/=.*//')"
  done
}
