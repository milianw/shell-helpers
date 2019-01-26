#!/bin/sh

. /etc/icecream.conf

ping -i 0.5 -c 1 $ICECREAM_SCHEDULER_HOST 2>&1 > /dev/null
