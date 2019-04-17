#!/bin/sh

. /etc/icecream.conf

(echo "listcs"; sleep 1; echo "quit") | timeout 2 telnet $ICECREAM_SCHEDULER_HOST 8766 2> /dev/null | grep -Po "jobs=\d+/\d+" | sed -r 's#jobs=[0-9]+/##' | paste -sd+ | bc
