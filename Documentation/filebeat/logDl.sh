#!/bin/bash

# script simple permettant de télécharger les logs du numéro
# $SMALLER au numéro $BIGGER

SMALLER="1566050"
BIGGER="1566055"

SERVER_1="149.202.167.70"
SERVER_2="149.202.167.72"
SERVER_3="149.202.167.66"

rm -rf /tmp/logs_tf
mkdir /tmp/logs_tf

for i in $(seq $SMALLER 1 $BIGGER)
do
	#echo $i
	wget -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
	unzip /tmp/logs_tf/log_$i.log.zip -d /tmp/logs_tf/
	rm /tmp/logs_tf/log_$i.log.zip
done

# for (( i = $SMALLER; i < $BIGGER; i=i+3 )); do
# 	# echo $i
	
# done