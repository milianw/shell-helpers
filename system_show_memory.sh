#!/bin/bash

#
# visualize memory consumption over time
# as recorded by pmap / system_track_memory.sh
# script
#

logfile=$1
shift 1

read -r -d '' plot <<GNUPLOT
set xlabel 'time in s';
set ylabel 'memory consumption in MB';
set key outside right maxcols 1;
set grid;
plot "$logfile.total" using 1:(\$2/1024) title "total" w lines, "$logfile.total" using 1:(\$3/1024) title "used" w lines
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
  plot="$plot,'$f' using 1:(\$2/1024) title '$title' w lines"
done

gnuplot -p -e "$plot"
