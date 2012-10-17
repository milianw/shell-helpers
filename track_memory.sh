#!/bin/bash

#
# track memory of given application, identified by PID,
# using pmap -x, to show RSS and Dirty memory usage.
#
# visualization can later on be done with the
# show_memory.sh script.
#

pid=$1
sleep=1;

if [[ "$(ps -p $pid 2>/dev/null | grep $pid)" == "" ]]; then
  # maybe a command was given
  if [[ "$(which $1)" != "" ]]; then
    echo "launching: $@"
    $@ &
    pid=$!
  fi
else
  if [[ "$2" != "" ]]; then
    sleep=$2
  fi
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

read -r -d '' summer <<'AWK'
{
  if ($1 == "total") {
    rss = $4
    dirty = $5
  } else if ($7 == "anon") {
    heap += $3
  } else if ($7 == "stack") {
    stack += $3
  }
}
END {
  print rss,dirty,heap,stack
}
AWK

while [[ "$(ps -p $pid | grep $pid)" != "" ]]; do
  echo "snapshot " $pid
  pmap -x $pid | awk "$summer" >> $logfile
  sleep $sleep
done

echo "done tracking, visualizing"
$(dirname $0)/show_memory.sh "$logfile"

# kate: replace-tabs on;
