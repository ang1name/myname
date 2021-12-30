chkroute()
{
  host=$1
  port=$2
  line=$3
  [ -z "$3" ] && line=1
  ps -eaf | grep "rvsroute$3 -a"  | grep -v grep
  if [ $? != 0 ]
  then
    echo "restart rvsroute$line"
    rvsroute$3 -a 1 -n $host -s $port -l /rvslog/$line &
    sleep 20
    x=1
    ps -eaf | grep "rvsroute$3 -a"  | grep -v grep
    ret=$?
    echo "RETURN CHECK STATUS $ret"
    while [ $ret != 0 -a $x -lt 2 ]
    do
      echo "Retry restart $line $x after 5 second"
      sleep 20
      rvsroute$3 -a 1 -n $host -s $port -l /rvslog/$line &
      x=`expr $x + 1`
      ps -eaf | grep "rvsroute$3 -a"  | grep -v grep
    done
  fi
}

chkroute 117.54.12.181 50099 ""
echo "Restart check finish"

