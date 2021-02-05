# C, C++

alias astyle-my="astyle \
  --style=1tbs \
  --indent=spaces=4 \
  --align-pointer=type \
  --align-reference=type \
  --break-closing-brackets \
  --add-brackets \
  --convert-tabs \
  --close-templates \
  --unpad-paren \
  --pad-header \
  --pad-oper"

# Colored GCC warnings and errors.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

MAKEFLAGS="-j$(nproc)"
export MAKEFLAGS
alias make='make ${MAKEFLAGS}'
