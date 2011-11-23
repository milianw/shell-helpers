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
alias debug='gdb --eval-command="run" --args'

# always use english here se we can search for the error messages
alias make="LANG=en_US make -j 3"

# I always want to install all updates
alias apupgrade="sudo aptitude update; sudo aptitude -y dist-upgrade"

# sometimes I want to clean all files which are not tracked by svn
alias svnclean="svn status | grep "^?" | cut -c 3- | xargs rm -Rf"

if [ -f /etc/arch-release ]; then
  # arch linux specific aliases
  alias upgradesystem='sudo yaourt -Syu --aur'
  # ack is called ack-grep under debian, and I got used to that name...
  alias ack-grep='ack'
fi

# damn you free, why have thy no -h...
alias free="free -m"

# mplayer with cache, e.g. for sshfs mounted shares and the like
alias netmplayer="mplayer -cache 8192"

alias kde-update-pim="kde-update akonadi kdepimlibs kdepim-runtime kdepim"
alias kde-update-kdev="kde-update kate kdevplatform kdevelop php php-docs qmake"
