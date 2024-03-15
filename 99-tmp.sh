# This is a spot to quickly dump stuff before I know where it should go.

alias date-ymd='date +"%Y-%m-%d"'

# Rename a file by adding the current date to the end, before the extension.
date-add() {
  printf "$1"
}

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

todo() {
  p="$BASHRC_DIR/todo"
  cat "$p"
  sep
  cat >> "$p"
}

v99() {
  vim "$BASHRC_DIR/99-tmp.sh"
}

alias fdl='fd -l'

########

user_dirs() {
  p="$HOME/.config/user-dirs.dirs"

  cat > "$p" << EOF
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run.
# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
#
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/download"
XDG_TEMPLATES_DIR="$HOME/desktop"
XDG_PUBLICSHARE_DIR="$HOME/desktop"
XDG_DOCUMENTS_DIR="$HOME/desktop"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pix"
XDG_VIDEOS_DIR="$HOME/video"
EOF

  . "$p"

  mkdir -p "$XDG_DESKTOP_DIR"
  mkdir -p "$XDG_DOWNLOAD_DIR"
  mkdir -p "$XDG_TEMPLATES_DIR"
  mkdir -p "$XDG_PUBLICSHARE_DIR"
  mkdir -p "$XDG_DOCUMENTS_DIR"
  mkdir -p "$XDG_MUSIC_DIR"
  mkdir -p "$XDG_PICTURES_DIR"
  mkdir -p "$XDG_VIDEOS_DIR"
}

alias mv='mv -i'
alias rm='rm -I'
#rm() { echo 'use rip'; }
alias lower='rename '\''s/(.*)/\L$1/'\'''

# TODO: Find out why this doesn't happen automatically
alias x='xrdb -merge ~/.Xresources'

get_abs_filename() {
  # $1 : relative filename
  if [ -d "$(dirname "$1")" ]; then
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
  fi
}
# <- returns empty string for invalid path

# 2022-04-07 konsole is in the process of getting support for the kitty protocol, that is needed for viu to be able to display images directly in the console.
# feh() { echo 'Use viu'; }
feh() { echo 'Use gthumb'; }

alias dmesg='dmesg --human --color=always | bat --pager="less -iSR"'

# alias i='sudo apt install'

i() {
  for p in "$@"; do
    if sudo apt install "$p"; then
      printf >> "$HOME/installed.txt" '%s\n' "$p"
    fi
  done
}

# cargo install async-cmd

alias mpa='mpv --no-audio-display'
alias d='dust -d1'
alias dfc='dfc -dug'


# rsync notes
# When filtering, ONLY filter ending with '/' matches dirs.
# Without filter matching dirs, will not recurse.
# To recurse when filtering, add filters to end of filter list: -f '+ */' -f '- *'
# Recursively copy only *.EXT, creating dirs only as required: rs src dst --prune-empty-dirs -f '+ *.EXT' -f '+ */' -f '- *'
# folder/***: The third asterisk is needed when using a slash after the directory name, it is a shortcut for folder/ and folder/**
#
# From man:
#
# Here’s an example that copies all .pdf files in a hierarchy, only creating the necessary destination directories to hold the .pdf files, and ensures that any superfluous files and directories in the destination are re‐
# moved (note the hide filter of non-directories being used instead of an exclude):
#
# rsync -avm --del --include=’*.pdf’ -f ’hide,! */’ src/ dest
# 
# If you didn’t want to remove superfluous destination files, the more time-honored options of "--include='*/' --exclude='*'" would work fine in place of the hide-filter (if that is more natural to you).

# Tidy
confirm() {
	read -p "Are you sure? " -n 1 -r
	echo
	[[ $REPLY =~ ^[Yy]$ ]]
}

alias tidy-recursive-rename-lower-case="confirm && rename 's/(.*)/\L\$1/' **"
alias tidy-gopro-remove-meta='confirm && find . \( -iname "*.thm" -or -iname "*.lrv" -or -iname "*.jpg" -or -iname "*.url" \) -delete'

alias nvidia-led-off='nvidia-settings --assign GPULogoBrightness=0'
nvidia-led-off

# Move without clobber
alias rsmi='rsync --recursive --links --times --info=progress2 --remove-source-files --ignore-existing'

alias hd-standby='sudo hdparm -S60 /dev/sd[abcdefgh]'
alias hd-on='sudo hdparm -S0 /dev/sd[abcdefgh]'
alias hd-check-standby='sudo hdparm -C /dev/sd[abcdefgh]'

alias cargo-update='rustup update && cargo install cargo-update; cargo install-update -a'
alias 99='vim $HOME/bin/bashrc.d/99-tmp.sh'

mpv-random() {
  find "${1:?}" -print0 | sort --random-sort -z | xargs -0 mpv
}

