function watch-tree() { watch -n .5 --difference --color exa --long --tree --bytes --sort=time --reverse --color=always "$1"; }

# TODO: This pattern gives a nice progress bar while compressing. Make a function / alias.
# tar -c dot-minders | xz -vv --lzma2=dict=192MiB big_foo.tar

# Misc
alias pkill="pkill -ief"

alias iotop="sudo iotop -o -d 2 -P"

# watch df
alias watch='watch --color --differences'
alias wdf="watch -n 2 --color --differences df --type ext4"

# Symlinks
# Create relative symlink(s) to executable(s) in ~/bin
alias sbin="ln -srft $HOME/bin"

function dd() { dd if="$1" of="$2" bs=4M oflag=direct status=progress; }

# Show disk and memory usage
alias f='df -h /dev/sd* | grep -v udev && echo && free -mh'

alias m4b-tool='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt m4b-tool'

alias trash-empty='gio trash --empty'

# Settings for ls, du and other commands from the coreutils package.
# Group file sizes by thousands
export BLOCK_SIZE="'1"
# Don't append type indicator character to the end of filenames (@, /, etc)
export QUOTING_STYLE=literal
# Sensible time format (ISO 8601 with space instead of "T" separator)
export TIME_STYLE='+%Y-%m-%d %H:%M:%S'
# Make 'less' scroll lines just before a match into view (shows context)
# and pass though ANSI color codes.
export LESS="${LESS}j5 -R"

# Enabled multithreading for xz
export XZ_OPT="--threads=16"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
  ;;
*) ;;
esac

#XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/dahl/.local/share/flatpak/exports/share${XDG_DATA_DIRS:+:${XDG_DATA_DIRS}}"; export XDG_DATA_DIRS;

alias m4b-tool='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt m4b-tool'

# MP3, ID3

# mp3val
# id3convert
# id3*

#
# Standard utility settings
#
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Grep with color, current dir, recursive, Perl compatible regexp
function gr() { grep -R --perl-regex --color=always "$1" . | less --raw; }

alias notheme='env GTK2_RC_FILES=/usr/share/themes/Mint-X-Teal/gtk-2.0/gtkrc'
alias dcm2txt='for f in *.dcm; do dcmdump > $f.txt $f; done'
alias start='xdg-open'
alias rmempty='find . -empty -delete'
# Case insensitive search in man pages
alias man='man -i'
alias v='gpicview'
# Case insensitive less
alias less='less -i'
alias nobuffer='stdbuf -i0 -o0 -e0'
alias make='make -j16'
# Make pipe look like terminal
faketty() {
  script -qfc "$(printf "%q " "$@")" /dev/null
}

# Locate with ls -l on each result
function locates() { locate -0 "$1" | xargs -0 --no-run-if-empty ls -ld; }

#
# Alias
#

# The MPV video player worked with CUDA hardware decoding out of the box,
# smoothly playing 2160p HEVC (H.265) 36,909 kbps video on my GTX1060. Couldn't
# get VLC and MPlayer to play the file smoothly even after a bunch of fiddling.
#alias mpv='mpv --vo=opengl --hwdec=cuda'
alias vlc='echo Use mvp \(command line\) or smplayer \(gui\)'
alias mplayer='echo Use mvp \(command line\) or smplayer \(gui\)'
alias sed="echo Use perl -i -pe 's/x/y/' file"

# Capture stdin in X clipboard, removing final newline
alias clip="perl -pe 'chomp if eof' | xclip -se c"

alias grep='grep --color=auto --perl-regexp'
#alias fgrep='fgrep --color=auto'
#alias egrep='egrep --color=auto'
#alias grep='rg'

alias notheme='env GTK2_RC_FILES=/usr/share/themes/Mint-X-Teal/gtk-2.0/gtkrc'
alias dcm2txt='for f in *.dcm; do dcmdump > $f.txt $f; done'
alias start='gtk-launch'
alias rmempty='find . -empty -delete'

alias nobuffer='stdbuf -i0 -o0 -e0'

# rsync
# Filtering: Remember the *** operator that was added in 2.6.7 (2006) and that 'dir/**' does not match dirs.
# Copying only dirs d1 and d2: rs -f '+ d1/***' -f '+ d2/***' -f '- *'
RSYNC_ARGS='--recursive --links --times --info=progress2'
# shellcheck disable=SC2139
alias rs="rsync $RSYNC_ARGS"

# Case insensitive search in man pages
alias man='man -i'

#alias v='gpicview'
alias v='nomacs'

alias lsblk='lsblk -o +uuid,label,hotplug,tran'

locll() { locate -0 "$1" | xargs -0 ls -l; }

#function pretty_csv {
#    column -t -s, -n "$@" | less -F -S -X -K
#}

# tar, parallel compression with xz
alias tz='tar -c -I pxz -f'

# Make 'less' more friendly for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias xml="xmlstarlet"

# Create a compressed backup of a dir (recursive)
function bak() {
  is_installed 'pixz' || {
    echo 'Missing pixz: sudo apt install pixz'
    return 1
  }
  src="${1}"
  [[ -e ${src} ]] || {
    echo "Source does not exist: ${src}"
    return 1
  }
  dst="$(basename "${src}")-bak-$(iso-now).txz"
  [[ ! -e ${dst} ]] || {
    echo "Backup already exists: ${dst}"
    return 1
  }
  echo "Creating backup: ${src} -> ${dst}"
  tar --use-compress-program=pixz -cf "${dst}" "${src}"
}
