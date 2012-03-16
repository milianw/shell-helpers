#!/bin/bash

#
# track memory of given application, identified by PID,
# using pmap -x, to show RSS and Dirty memory usage.
#
# visualization can later on be done with the
# show_memory.sh script.
#

pid=$1
sleep=$2;

if [[ "$sleep" == "" ]]; then
  sleep=1
fi

if [[ "$(ps -p $pid | grep $pid)" == "" ]]; then
  echo "cannot find program with pid $pid"
  echo "track_memory.sh PID [SLEEP_TIMEOUT]"
  echo
  echo "example: track_memory.sh \$(pidof someapp) 0.1"
  exit
fi

logfile=mem.log.$pid

echo "# $(ps -o command= -p $pid)" > $logfile
echo "# $sleep" >> $logfile

cat $logfile

while [[ "$(ps -p $pid | grep $pid)" != "" ]]; do
  echo "snapshot " $pid
  pmap -x $pid | tail -n1 >> $logfile
  echo "$sleep"
  sleep $sleep;
done

echo "done tracking, visualizing"
$(dirname $0)/show_memory.sh "$logfile"
