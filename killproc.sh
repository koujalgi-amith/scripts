if [[ $# -eq 0 ]]; then
	echo "Process name not provided."
	echo "Usage: fkill <process-name>"
	exit
fi

procname=$1

echo "Killing all processes named $procname..."

PIDS=`ps -ax | grep '$procname'`

echo $PIDS


for pid in $(ps -ax | grep '$procname' | awk '{print $1;}');
do
	kill -9 $pid;
done
