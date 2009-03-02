#!/bin/bash

# colors, yay!
alias svndiff="svn diff --diff-cmd=colordiff"
alias grep='grep --colour'

# for readline support
alias gnuplot='rlwrap -a -c gnuplot'

# run php on cli with special config for profiling
alias phprofile='php -c /etc/php5/cli/profile/'

# shortcut
alias compile++='g++ -Wall -pedantic -ansi'

# run program in gdb
# usage: debug APP APP_ARGS
alias debug='gdb --eval-command="run" --args'

# always use english here se we can search for the error messages
alias make="LANG=en_US make"