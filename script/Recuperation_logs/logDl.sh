#!/bin/bash

# script simple permettant de télécharger les logs du numéro
# $SMALLER au numéro $BIGGER

SMALLER=$1
BIGGER=$2

rm -rf /tmp/logs_tf
mkdir /tmp/logs_tf

# TODO : Optimisation possible ?
for i in $(seq $SMALLER 1 $BIGGER)
do
	#echo $i
	wget -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
	unzip /tmp/logs_tf/log_$i.log.zip -d /tmp/logs_tf/
	rm /tmp/logs_tf/log_$i.log.zip
done

# TODO : trouver comment savoir que logstash a tout reçu
sleep 2

rm /tmp/logs_tf/*