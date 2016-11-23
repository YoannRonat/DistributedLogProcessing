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
	wget --quiet -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
	# Permet de s'assurer que TOUS les logs souhaités soient téléchatgés
	SUCCESS=$?
	while [ $SUCCESS -ne "0" ]
	do
		wget --quiet -P /tmp/logs_tf http://logs.tf/logs/log_$i.log.zip
		SUCCESS=$?
	done
	unzip /tmp/logs_tf/log_$i.log.zip -d /tmp/logs_tf/
	rm /tmp/logs_tf/log_$i.log.zip
	# Envoi à serveur1 du fichier reçu
	ssh -i ~/.ssh/xnet xnet@server-1 "echo $i >> recu.txt"
done

HOSTNAME=$(hostname)
ssh -i ~/.ssh/xnet xnet@server-1 "echo $HOSTNAME >> done.txt"