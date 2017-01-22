#!/bin/bash
# This script launch the log processing using Zookeeper
# In order to estimate the end of the log processing, this script regulary count the
# number of records
# Be carefull, in case of a benchmark each check may slow down a bit the system,
# so real execution time may be a bit higher
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
CLEAN="\033[2K"
echo_cmd="/bin/echo"
# Waiting time beetwen each check avoiding too much requests
sleep_time=5

usage()
{
	echo 'Utilisation : ./run_benchmark.sh machines log_start log_number'
}

get_record_number () {
	curl -s -XGET server-1:9200/filebeat-0/_count?pretty | grep count | sed -e 's/  "count" : //' -e 's/,//';
}

if [ "$#" -ne 3 ]; then
	echo "Erreur : Nombre d'argument invalide"
	usage
	exit 1
fi

MACHINES=$1
LOG_START=$2
LOG_NUM=$3

# 2 records are created for each log (blue & red team winning status)
ENTRY_NUM=$((2*LOG_NUM))

# Getting current entry number
record_offset=$(get_record_number)

$echo_cmd -e "$VERT""Log processing started"$NORMAL" ($LOG_NUM logs)"
java -cp ./resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Client $MACHINES $LOG_START $LOG_NUM > /dev/null
if [ $? -ne 0 ]; then
	exit $?
fi
$echo_cmd -e "$VERT""Logs Downloaded""$NORMAL"

records_nb=0
begin_time=$(date +%s)
current_time=$(date +%s)
while [ "$records_nb" -lt "$ENTRY_NUM" ]; do
	sleep $sleep_time
	current_time=$(date +%s)
	waiting_time=$(($LOG_NUM))
	if [ "$waiting_time" -le $((current_time-begin_time)) ]; then
		# Get the record number registered 
		# (number of log finished to be processed)
		records_nb=$(get_record_number)
		# Compute the number of created record since the script began
		records_nb=$((records_nb-record_offset))
		# Display progress informations
		$echo_cmd -ne "$CLEAN\r""Waiting for end of log processing : " $((current_time-begin_time)) "s ($records_nb/$ENTRY_NUM records)"
		# Debug line
		# echo "records: "$records_nb", begin: "$record_offset
	else
		# Display progress informations
		$echo_cmd -ne "$CLEAN\r"$((current_time-begin_time))"/"$waiting_time"s before first check"
	fi
done
$echo_cmd -ne "$CLEAN\r$VERT""End of log processing""$NORMAL""\n"
