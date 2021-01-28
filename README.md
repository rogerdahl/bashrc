# bashrc.d

## Install

```shell script
$ bash -c '
  set -x
  BASHRC_REL_DIR="bin/bashrc.d"
  BASHRC_DIR="$HOME/$BASHRC_REL_DIR"
  mkdir -p "$BASHRC_DIR"
  git clone '\''git@github.com:rogerdahl/bashrc.git'\'' "$BASHRC_DIR"
  echo >> "$HOME/.bashrc" "export BASHRC_DIR=\"\$HOME/$BASHRC_REL_DIR\""
  echo >> "$HOME/.bashrc" ". \"\$HOME/$BASHRC_REL_DIR/init.sh\""
'
```

* The existing ~/.bashrc file is moved into ~/bin/bashrc.d/bashrc.original

##

# Custom locale

The default sort order (collation) is horrendous under Unix. It may be ok for some casual users, but it's just a mess for devs. It ignores many characters, such as `.` and `_`. In addition, it mixes small and capital letters. The result is all of these are sorted together: `_a`, `.a`, ` a`, `_A`, `.A`, ` A`

The default date format (at least in the `en_US.utf8` locale) is not good for devs either, as they jumble up the order of least to most significant values, and sorting them alphabetically does not cause them to be sorted chronologically.

This generates a custom locale that:

- Does not mix capitalized and non-capitalized letters, which is especially helpful on filenames.
- Does not ignore any leading characters, which allows dot-files to be sorted separately from other files, and makes it possible to use prefixes such as "_" to force the sort order, e.g., to show important files on top of the list.
- Has an ISO 8601-like date format: %Y-%m-%d %H:%M:%S


#### untouched (no .bashrc)

LANGUAGE=en_US
GDM_LANG=en_US
LANG=en_US.UTF-8



## Pi 4, untouched env

BLOCK_SIZE='1
DISPLAY=localhost:10.0
ESP_ROOT=/home/dahl/hdd/sdk/esp8266
GCC_COLORS=error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01
HOME=/home/pi
IDF_PATH=/home/pi/bin/esp32/esp-idf

LANG=en_US.UTF-8

LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64:/home/pi/bin/stlink:
LESSCLOSE=/usr/bin/lesspipe %s %s
LESS=j5 -R
LESSOPEN=| /usr/bin/lesspipe %s
LOGNAME=pi
MAIL=/var/mail/pi
NO_AT_BRIDGE=1
_OLD_VIRTUAL_PS1=\[\e]0;\u@\h \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\t\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ 
PATH=/home/pi/bin:/home/pi/.pyenv/plugins/pyenv-virtualenv/shims:/home/pi/.pyenv/shims:/home/pi/.pyenv/bin:/home/pi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
PS1=(global-3.8.1) \[\e]0;\u@\h \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\t\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ 
PWD=/home/pi
PYENV_ROOT=/home/pi/.pyenv
PYENV_SHELL=bash
PYENV_VIRTUAL_ENV=/home/pi/.pyenv/versions/3.8.1/envs/global-3.8.1
PYENV_VIRTUALENV_INIT=1
QT_ACCESSIBILITY=1
QT_AUTO_SCREEN_SCALE_FACTOR=0
QT_PLATFORM_PLUGIN=qt5ct
QT_QPA_PLATFORMTHEME=qt5ct
QT_SCALE_FACTOR=1
QUOTING_STYLE=literal
SHELL=/bin/bash
SHLVL=0

SSH_AUTH_SOCK=/tmp/ssh-e0SqLXuEyp/agent.26987
SSH_CLIENT=192.168.1.10 56062 22
SSH_CONNECTION=192.168.1.10 56062 192.168.1.154 22
SSH_TTY=/dev/pts/1

TERM=xterm-256color
TEXTDOMAIN=Linux-PAM
USER=pi
_=/usr/bin/env
VIRTUAL_ENV=/home/pi/.pyenv/versions/3.8.1/envs/global-3.8.1
XDG_RUNTIME_DIR=/run/user/1000
XDG_SESSION_CLASS=user
XDG_SESSION_ID=65
XDG_SESSION_TYPE=tty
