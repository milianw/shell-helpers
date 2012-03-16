pid=$1
sleep=$2;

if [[ "$sleep" == "" ]]; then
  sleep=1;
fi

if [[ "$(ps -p $pid | grep $pid)" == "" ]]; then
  echo "cannot find program with pid $pid"
  exit
fi

logfile=mem.log.$pid

echo "# $(ps -o command= -p $pid)" > $logfile
echo "# $sleep" >> $logfile

while [[ "$(ps -p $pid | grep $pid)" != "" ]]; do
  echo "snapshot " $pid
  pmap -x $pid | grep total >> $logfile
  sleep $sleep;
done

echo "done tracking, visualizing"
$(dirname $0)/show_memory.sh "$logfile"
