#!/bin/bash

#
# visualize memory consumption over time
# as recorded by pmap / track_memory.sh
# script
#

logfile=$1

if [ ! -f "$logfile" ]; then
  echo "cannot find memory logfile: $1"
  echo
  echo "usage: show_memory.sh LOGFILE"
  echo
  echo "example: show_memory.sh mem.log.12345"
  exit
fi

title=$(head -n1 "$logfile")
timeout=$(head -n2 "$logfile" | tail -n1)

title=${title/\# /}
timeout=${timeout/\# /}

if [[ "$2" == "smooth" ]]; then
  lineType="smooth bezier"
else
  lineType="w lines"
fi

read -r -d '' plot <<GNUPLOT
set title '$title';
set xlabel 'time in s';
set ylabel 'memory consumption in MB';
set key bottom right;
set grid;
plot \
  '$logfile' using (\$0 * $timeout):(\$1/1024) $lineType title 'RSS', \
  '$logfile' using (\$0 * $timeout):(\$2/1024) $lineType title 'Dirty', \
  '$logfile' using (\$0 * $timeout):(\$3/1024) $lineType title 'Heap', \
  '$logfile' using (\$0 * $timeout):(\$4/1024) $lineType title 'Stack' ;
  ;
GNUPLOT

gnuplot -p -e "$plot"
