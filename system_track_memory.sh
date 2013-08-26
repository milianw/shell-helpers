#!/bin/bash

#
# track memory of the whole system.
# iterates over all /proc/$PID/ folders and calls
# pmap -x on the given PID to show RSS and Dirty memory usage.
#
# visualization can later on be done with the
# system_show_memory.sh script.
#

xBaseline=$(date +'%s')

filter=$@

if [[ "$(pmap --version 2>&1 | grep BusyBox)" ]]; then
    rssCol=3
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
    if (pss) {
        print (systime()-x0),pss,dirty,heap,stack
    }
}
AWK
)
else
    rssCol=4
    summer=$(cat <<'AWK'
{
    if ($1 == "total") {
        haveTotal=1
        rss = $4
        dirty = $5
    } else if ($7 == "anon") {
        heap += $3
    } else if ($7 == "stack") {
        stack += $3
    }
}
END {
    if (haveTotal) {
        print (systime()-x0),rss,dirty,heap,stack
    }
}
AWK
)
fi

isFiltered()
{
    local f
    for f in $filter; do
        if [[ "$1" == *"$f"* ]]; then
            return 1
        fi
    done
    return 0
}

logfile=mem.log.system.$$

if [[ "${TRACK_MEMORY_OUTPUTDIR}" != "" ]]; then
    logfile=${TRACK_MEMORY_OUTPUTDIR}/$logfile
fi

touch "$logfile"
logfile=$(readlink -f "$logfile")

rm $logfile*

cd /proc

echo "# total" > $logfile.total

while true; do
    echo "snapshot"
    free -k | grep Mem: | awk -v x0=$xBaseline '{print (systime()-x0),$2,$3,$4;}' >> $logfile.total
    for pid in $(ls -d [0-9]*); do
        if [ ! -f "$logfile.$pid" ]; then
            exe=$(readlink -f $pid/exe)
            if [[ "$exe" == "" ]]; then
                continue;
            fi
            isFiltered $exe && continue;
            echo "# $pid $(basename $exe)" >> $logfile.$pid
        fi
        # more complex: TODO, use a switch to enable this
        # pmap -x $pid | awk -v x0=$xBaseline "$summer" >> $logfile.$pid
        pmap -x $pid | tail -n1 | awk -v x0=$xBaseline -v col=$rssCol '{print (systime()-x0),$col}' >> $logfile.$pid
    done
    sleep 1
done

visualizer=$(dirname $0)/system_show_memory.sh

if [ -f "$visualizer" ]; then
    echo "done tracking, visualizing $logfile")
    "$visualizer" "$logfile"
else
    echo "done, generated $logfile")
fi

# kate: replace-tabs on;
