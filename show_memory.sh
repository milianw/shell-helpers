logfile=$1

# total:
#  '$logfile' using 3 w lines title 'Kbytes', \

gnuplot -p -e "
set xlabel 'snapshot ~1s';
set ylabel 'memory consumption in kB';
set key bottom right;
plot \
  '$logfile' using 4 w lines title 'RSS' lt 1, \
  '$logfile' using 4 smooth bezier w lines title 'RSS (smooth)' lt 7, \
  '$logfile' using 5 w lines title 'Dirty' lt 2, \
  '$logfile' using 5 smooth bezier w lines title 'Dirty (smooth)' lt 3;
";
