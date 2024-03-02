# Docker based commands

prettier() {
  local prettier_image="tmknom/prettier"
  # docker run: Docker receives everything up to the image name, and prettier receives
  # everything after the image name.
  # --rm: Automatically delete container on exit
  docker run \
    --rm \
    --volume "$PWD:/work" \
    "$prettier_image" \
    --config '/config/prettier.json' \
    --write \
    "$@"
    # --parser=markdown
}
