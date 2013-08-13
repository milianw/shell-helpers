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

if [[ "$(pmap --version 2>&1 | grep BusyBox)" ]]; then
    summer=$(cat <<'AWK'
{
    if ($1 == "total") {
        pss = $3
        dirty = $4
    } else if ($8 == "anon" || $7 == "[heap]") {
        heap += $3
    } else if ($7 == "[stack]") {
        stack += $3
    }
}
END {
    print pss,dirty,heap,stack
}
AWK
)
else
    summer=$(cat <<'AWK'
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
)
fi

if [[ "$pid" != "" && ! -d /proc/$pid/ ]]; then
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

if [[ "$pid" == "" || ! -d /proc/$pid/ ]]; then
  echo "cannot find program with pid $pid"
  echo "track_memory.sh PID [SLEEP_TIMEOUT]"
  echo
  echo "example: track_memory.sh \$(pidof someapp) 0.1"
  exit
fi

logfile=mem.log.$pid

echo "# $(cat /proc/$pid/cmdline)" > $logfile
echo "# $sleep" >> $logfile

cat $logfile

while [ -d /proc/$pid/ ]; do
  echo -n "snapshot $pid: "
  pmap -x $pid | awk "$summer" | tee -a $logfile
  sleep $sleep
done

visualizer=$(dirname $0)/show_memory.sh

if [ -f "$visualizer" ]; then
    echo "done tracking, visualizing "$(readlink -f "$logfile")
    "$visualizer" "$logfile"
else
    echo "done, generated "$(readlink -f "$logfile")
fi

# kate: replace-tabs on;
