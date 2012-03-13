pid=$1

if [[ "$(ps -p $pid | grep $pid)" == "" ]]; then
  echo "cannot find program with pid $pid"
  exit
fi

logfile=mem.log.$pid

while [[ "$(ps -p $pid | grep $pid)" != "" ]]; do
  echo "snapshot " $pid
  pmap -x $pid | grep total >> $logfile
  sleep 1;
done

echo "done tracking, visualizing"
$(dirname $0)/show_memory.sh "$logfile"
