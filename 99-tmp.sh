# This is a spot to quickly dump stuff before I know where it should go.

alias date-ymd='date +"%Y-%m-%d"'

# Rename a file by adding the current date to the end, before the extension.
date-add() {
  printf "$1"
}

padd "$(npm bin)"

# Split path and extension

split-path() {
  # filename=$(basename -- "$fullfile")
  ext="${path##*.}"
  name="${path%.*}"
  printf '%s\0%s' "$ext" "$name"
  #return (
  #  "$ext"
  #  "$name"
  #)
}

prompt_simple() {
  export PROMPT_METHOD='{ PS1="$ "; }'
}

export PICO_SDK_PATH=/home/dahl/sdk/pico2/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/dahl/sdk/pico2/pico/pico-examples
export PICO_EXTRAS_PATH=/home/dahl/sdk/pico2/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/dahl/sdk/pico2/pico/pico-playground

# Unmount anything that's hotplugged (usually USB flash drive)
# We shadow the name of the old `eject` command, which is intended for CDROM drives.
eject() {
  IFS=$'\n'
  for line in $(lsblk --paths --pairs --dedup NAME --output MOUNTPOINT,HOTPLUG); do
    eval "$line"
    [[ -n $MOUNTPOINT && $HOTPLUG == "1" ]] && {
      printf 'Unmounting: %s\n' "$MOUNTPOINT"
      umount "$MOUNTPOINT"
    }
  done
  unset IFS
}


padd "$(npm bin)"

todo() {
  p="$HOME/bin/bashrc.d/todo"
  cat "$p"
  sep
  cat >> "$p"
}
