#!/bin/sh

if [ -z "$(pidof lttng-sessiond)" ]; then
    sudo lttng-sessiond --daemonize
fi

sudo lttng create -o ~/lttng-traces/$(date -Iseconds)
sudo lttng enable-channel kernel -k --subbuf-size 16M --num-subbuf 8
sudo lttng enable-event -c kernel -k -a
sudo lttng enable-channel ust -u --subbuf-size 16M --num-subbuf 8
sudo lttng enable-event -c ust -u -a
sudo lttng start
$@
sudo lttng stop

sudo chmod a+rx -R ~/lttng-traces
