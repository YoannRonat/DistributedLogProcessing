#!/bin/bash

# script simple permettant de télécharger les logs du numéro
# $SMALLER au numéro $BIGGER
# Doit être exécuté sur les machines esclaves

SMALLER=$1
BIGGER=$2

rm -rf /tmp/logs_tf
mkdir /tmp/logs_tf

# TODO : Optimisation possible ?
for i in $(seq $SMALLER 1 $BIGGER)
do
	#echo $i
	wget -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
	# Permet de s'assurer que TOUS les logs souhaités soient téléchatgés
	SUCCESS=$?
	while [ $SUCCESS -ne "0" ]
	do
		wget -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
		SUCCESS=$?
	done
	unzip /tmp/logs_tf/log_$i.log.zip -d /tmp/logs_tf/
	rm /tmp/logs_tf/log_$i.log.zip
done

# TODO : trouver comment savoir que logstash a tout reçu
#sleep 2

#rm /tmp/logs_tf/*