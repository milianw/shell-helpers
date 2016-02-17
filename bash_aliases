#!/bin/bash

# colors, yay!
alias ls='ls --color=auto'
alias svndiff="svn diff --diff-cmd=colordiff"
alias grep='grep --colour'

# run php on cli with special config for profiling
alias phprofile='php -c /etc/php5/cli/profile/'

# shortcut
alias compile++='g++ -Wall -pedantic -ansi'

# run program in gdb
# usage: debug APP APP_ARGS
alias debug='QT_XCB_NO_GRAB_SERVER=1 gdb --eval-command="run" --args'

# I always want to install all updates
alias apupgrade="sudo aptitude update; sudo aptitude -y dist-upgrade"

# sometimes I want to clean all files which are not tracked by svn
alias svnclean="svn status | grep "^?" | cut -c 3- | xargs rm -Rf"

if [ -f /etc/arch-release ]; then
  # arch linux specific aliases
  alias upgradesystem='yaourt -Syu --aur'
  # ack is called ack-grep under debian, and I got used to that name...
  alias ack-grep='ack'
fi

alias free="free -h"

# mplayer with cache, e.g. for sshfs mounted shares and the like
alias netmplayer="mplayer -cache 8192"

alias kde-update-pim="kde-update akonadi nepomuk-core nepomuk-widgets kdepimlibs kdepim-runtime kdepim"
alias kde-update-kdev="kde-update kate kdevplatform kdevelop kdev-php kdev-php-docs kdev-qmake"

alias isomount="sudo mount -o loop -t iso9660"
alias enable_icc="source ~/.bin/enable_icc.sh"

alias webkit-debug="export QTWEBKIT_INSPECTOR_SERVER=9999"

alias kdab-berlin-vpn="sudo openvpn /etc/openvpn/office-berlin.ovpn"

alias nvidia-run="vblank_mode=0 primusrun"
