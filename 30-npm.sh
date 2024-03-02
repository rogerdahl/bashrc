## NPM package manager
#
#cd "$(dirname "$0")" || exit
#
#is_installed() {
#  command -v "$1" >/dev/null 2>&1
#  return $?
#}
#
#npm_path="$(npm bin 2>/dev/null)"
#padd "$(npm bin 2>/dev/null)"
#
#install_npm_prettier() {
#  [[ -n "$npm_path" ]] || {
#    sudo apt install npm
#  }
#  echo "legacy-peer-deps=true" >> ~/.npmrc
#  npm install prettier
#}
#
## npm_path="$(npm bin)" 2>&1
## echo $nnpm_path
## npm_path="$(npm bin)" 2>&1
## echo $npm_path
## npm_path="$(npm bin 2>/dev/null)"
#
## npm-do() { (PATH=$(npm bin):$PATH eval $@); }
#
## docker run --volume "$PWD:/work" tmknom/prettier --config=./prettier.json --write web/*.js web/*.css
#
##padd $(npm bin)
#npm_path="$(npm bin)" 2>&1
#
##npm-do prettier --config=./prettier.json --write web/*.js web/*.css
#padd ~/node_modules/.bin/
#
