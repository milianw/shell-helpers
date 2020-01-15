#!/bin/sh

. /etc/icecream.conf

timeout_1=1
timeout_2=2
if [[ "$(hostname)" == "milian-kdab2" ]]; then
    timeout_1=0.5
    timeout_2=0.5
fi

(echo "listcs"; sleep $timeout_1; echo "quit") | timeout $timeout_2 telnet $ICECREAM_SCHEDULER_HOST 8766 2> /dev/null | grep -Po "jobs=\d+/\d+" | sed -r 's#jobs=[0-9]+/##' | paste -sd+ | bc
