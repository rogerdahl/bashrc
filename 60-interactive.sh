# Misc

# Indent .sh files
# -w Write result back to file
# -i 2 Indent with 2 spaces (indents with tab by default)
alias shfmt="shfmt -w -i 2"
alias pkill="pkill -ief"

alias iotop="sudo iotop -o -d 2 -P"

# watch df
alias watch='watch --color --differences'
alias wdf="watch -n 2 --color --differences df --type ext4"

# Symlinks
# Create relative symlink(s) to executable(s) in ~/bin
alias sbin="ln -srft $HOME/bin"

dd() { printf 'Use mydd\n'; }
mydd() { sudo dd if="$1" of="$2" bs=4M oflag=direct status=progress; }

# Show disk and memory usage
alias f='df -h /dev/sd* | grep -v udev && echo && free -mh'

alias m4b-tool='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt m4b-tool'

alias trash-empty='gio trash --empty'

# Flatten dir hierarchy, show only mtime,size,name, order by mtime
alias find-flat="find . -type f -printf '%CY-%Cd-%Cm %CH:%CM:%CS %14s %f\n' | sort"

## If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm* | rxvt*)
#  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
#  ;;
#*) ;;
#esac

#XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/dahl/.local/share/flatpak/exports/share${XDG_DATA_DIRS:+:${XDG_DATA_DIRS}}"; export XDG_DATA_DIRS;

alias m4b_tool='docker run -it --rm -u $(id -u):$(id -g) -v "$(pwd)":/mnt m4b-tool'

# Invoke a command with '--help' and page the result
h() {
  "$1" --help | command rg --replace ’ --passthrough \' | bat --language=sh
}

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
gr() { grep -R --perl-regex --color=always "$1" . | less --raw; }

alias notheme='env GTK2_RC_FILES=/usr/share/themes/Mint-X-Teal/gtk-2.0/gtkrc'
alias dcm2txt='for f in *.dcm; do dcmdump > $f.txt $f; done'
alias start='xdg-open'

rmempty() {
  find "${1:?}" -empty -delete
}

# Case insensitive search in man pages
alias man='man -i'
alias v='gpicview'
# Case insensitive less
alias less='less -i'
alias make='make -j16'
# Make pipe look like terminal
faketty() {
  script -qfc "$(printf "%q \n" "$@")" /dev/null
}

# Locate with ls -l on each result
locates() { locate -0 "$1" | xargs -0 --no-run-if-empty ls -ld; }

#
# Alias
#

alias grep='grep --color=auto --perl-regexp'
#alias fgrep='fgrep --color=auto'
#alias egrep='egrep --color=auto'
#alias grep='rg'

alias notheme='env GTK2_RC_FILES=/usr/share/themes/Mint-X-Teal/gtk-2.0/gtkrc'
alias dcm2txt='for f in *.dcm; do dcmdump > $f.txt $f; done'
alias start='gtk-launch'

alias nobuffer='stdbuf -i0 -o0 -e0'

# rsync
# Filtering: Remember the *** operator that was added in 2.6.7 (2006) and that 'dir/**'
# does not match dirs. Copying only dirs d1 and d2:
# $ rs -f '+ d1/***' -f '+ d2/***' -f '- *'
# --no-inc-recursive: Scan all files to be transferred up front so that progress is correct
# from the start, at the cost of using more memory (paths for files to be transferred stored
# in memory)
RSYNC_ARGS='--recursive --links --times --info=progress2 --no-inc-recursive'
# shellcheck disable=SC2139
alias rs="rsync $RSYNC_ARGS"
# shellcheck disable=SC2139
alias rsm="rsync $RSYNC_ARGS --remove-source-files --prune-empty-dirs"
# Case insensitive search in man pages
alias man='man -i'

#alias v='gpicview'
alias v='nomacs'

alias lsblk='lsblk -o +uuid,label,hotplug,tran,fstype'

locll() { locate -0 "$1" | xargs -0 ls -l; }

#pretty_csv {
#    column -t -s, -n "$@" | less -F -S -X -K
#}

# tar, parallel compression with xz
alias tz='tar -c -I pxz -f'

# Make 'less' more friendly for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias xml="xmlstarlet"

# https://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/

# cd up
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."

# mkdir + cd
function md() {
  mkdir -p "$@" && eval cd "\"\$$#\""
}
