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
alias debug_main='QT_XCB_NO_GRAB_SERVER=1 gdb --eval-command="break main" --eval-command="run" --args'
alias debug_catch='QT_XCB_NO_GRAB_SERVER=1 gdb --eval-command="catch throw" --eval-command="run" --args'

# sometimes I want to clean all files which are not tracked by svn
alias svnclean="svn status | grep "^?" | cut -c 3- | xargs rm -Rf"

if [ -f /etc/arch-release ]; then
  # arch linux specific aliases
  alias upgradesystem='CMAKE_GENERATOR="Unix Makefiles" pikaur -Syu'
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

alias kdab-berlin-vpn="sudo openvpn /etc/openvpn/client/office-berlin.ovpn"

alias nvidia-run="vblank_mode=0 primusrun"

alias screen-omap5432="screen /dev/ttyUSB0 115200 8N1"

alias dropcaches="echo 3 | sudo tee /proc/sys/vm/drop_caches"

alias clazy-demo="CLAZY_CHECKS='level0,level1,level2,level3' clazy -I/usr/include/qt -I/usr/include/qt/QtCore -c -o /dev/null -std=c++11 -fPIC"
alias clazy-demo-gcc="g++ -Wall -Wpedantic -I/usr/include/qt -I/usr/include/qt/QtCore -c -o /dev/null -std=c++11 -fPIC"

alias aslr-disable="echo 0 | sudo tee /proc/sys/kernel/randomize_va_space"
alias aslr-enable="echo 2 | sudo tee /proc/sys/kernel/randomize_va_space"

alias toplev="python2 $HOME/projects/src/pmu-tools/toplev.py"
alias top="htop"

alias memcheck="valgrind --smc-check=all-non-file --track-origins=yes"

alias kde_reboot="qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 0 1 0"
alias kde_shutdown="qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 0 2 0"

alias minmaxavgstats="datamash -W min 1 max 1 mean 1 median 1 q1 1 q3 1 sstdev 1"

alias icemon="icemon -s 192.168.150.185"

alias restart_icecream="sudo systemctl restart icecream"

alias ls="lsd --group-dirs=first --icon=never"

alias diff="colordiff -u"

alias clang-ast-dump="clang -cc1 -ast-dump"
