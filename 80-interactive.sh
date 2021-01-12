function watch-tree() { watch -n .5 --difference --color exa --long --tree --bytes --sort=time --reverse --color=always "$1"; }

# TODO: This pattern gives a nice progress bar while compressing. Make a function / alias.
# tar -c dot-minders | xz -vv --lzma2=dict=192MiB big_foo.tar

# Misc
alias pkill="pkill -ief"
cd() { command cd "$@" && ll; }
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

# ripgrep with paging
function rgp() { rg -p "$1" | less -r; }

# Group file sizes by thousand in coreutils (ls, du, etc)
export BLOCK_SIZE="'1"

# Remove extra quoting in ls
export QUOTING_STYLE=literal

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

alias rs='rsync --recursive --verbose --progress --links --times --omit-dir-times'
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

# Pretty printing and syntax highlighting

# When using `bat` for syntax highlighting, I'm using `--language python` for some types
# for which `bat` has specific syntax highlighting available. I've tried those and found
# that highlighting as Python gives overall better results. What happens is that the
# specific highlighter will be semantically correct, for instance uniformly highlighting
# all string literals in a single color, while the Python highlighter thinks it's seeing
# operators and keywords in the strings, and highlights them as such. And it turns out
# that those are often significant to the human viewer, who knows what the information
# stored in the strings is.
# Put a path directly in the X clipboard
function pclip() { realpath "$1" | tr -d '\n' | xclip -se c; }

# Recursive egrep in current dir with context and color
function g() { grep -i -r --color=always -C 10 "$1" . | less -R; }
# bat --style params: changes,grid,numbers,header,snip

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

alias rs='rsync --recursive --links --times --info=progress2'
alias notheme='env GTK2_RC_FILES=/usr/share/themes/Mint-X-Teal/gtk-2.0/gtkrc'
alias dcm2txt='for f in *.dcm; do dcmdump > $f.txt $f; done'
alias start='gtk-launch'
alias rmempty='find . -empty -delete'

alias nobuffer='stdbuf -i0 -o0 -e0'

# rsync
# Filtering: Remember the *** operator that was added in 2.6.7 (2006) and that 'dir/**' does not match dirs.
# Copying only dirs d1 and d2: rs -f '+ d1/***' -f '+ d2/***' -f '- *'
RSYNC_ARGS='--recursive --verbose --progress --links --times'
alias rs="rsync $RSYNC_ARGS"

# Case insensitive search in man pages
alias man='man -i'

#alias v='gpicview'
alias v='nomacs'

alias lsblk='lsblk -o +uuid,label,hotplug,tran'

locll() { locate -0 "$1" | xargs -0 ls -l; }

# --sample-tidy --full-trace
# keep running. can't be combined with --sample-ask as pytest suppresses prompts. can be combined with --sample-write
# View log files
function pl() { black - <"$1" | bat --language python; }
alias batlog='bat --paging=never --language python'
# View XML docs (xmlstarlet + bat)
function px() { xmlstarlet format "$1" | bat --language xml; }
# View Python (Black + bat)
function pp() {
  black - <"$1" 2>/dev/null | bat --language python --style plain,changes,grid,numbers,snip
}
# View CSV file (column + bat)
# column: apt install util-linux
function view-csv() {
  column -t -s, -n "$@" |
    bat --wrap never --language python --pager 'less --no-init --quit-if-one-screen --chop-long-lines --quit-on-intr --RAW-CONTROL-CHARS'
}

#function pretty_csv {
#    column -t -s, -n "$@" | less -F -S -X -K
#}

# tar, parallel compression with xz
alias tz='tar -c -I pxz -f'

# Make 'less' more friendly for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias xml="xmlstarlet"
alias pipup='pip install --upgrade pip'
