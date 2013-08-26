#!/bin/bash

#
# visualize memory consumption over time
# as recorded by pmap / system_track_memory.sh
# script
#

logfile=$(echo $1 | sed 's/\.$//')
shift 1
echo $logfile

if [[ "$(ls $logfile.[0-9]*)" == "" ]]; then
    echo "usage: $0 mem.log.system.PID [FILTER]"
    echo "e.g.: $0 mem.log.system.15979 busybox"
    exit 1
fi

read -r -d '' plot <<GNUPLOT
set title "system memory consumption over time";
set xlabel 'time in s';
set ylabel 'memory consumption in MB';
set key outside right maxcols 1;
set grid;
plot "$logfile.total" using 1:(\$2/1024) title "total available memory" w lines lw 2, "$logfile.total" using 1:(\$3/1024) title "total used memory" w lines lw 2
GNUPLOT

for f in $(ls $logfile.[0-9]*); do
  title=$(head -n1 "$f")
  if [[ "$title" == "# $pid " ]]; then
    continue;
  fi
  for filter in $@; do
    if [[ "$title" == *"$filter"* ]]; then
      continue 2;
    fi
  done
  plot="$plot,'$f' using 1:(\$2/1024) title '$title' w lines lw 2"
done

gnuplot -p -e "$plot"
