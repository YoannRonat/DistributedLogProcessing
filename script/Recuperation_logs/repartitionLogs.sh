#!/bin/bash

# Script de répartition de téléchargement des logs entre les machines
# esclaves.
# Doit être exécuté sur la machine maitresse

VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"

# Premier log de 2016
FIRST="1181650"
FIRST="1500000"

CURRENT=$FIRST
PAS="99"

LAST=$(($FIRST+(3*($PAS+1))))

server1="149.202.167.70"
server2="149.202.167.72"
server3="149.202.167.66"

ssh -i ~/.ssh/xnet xnet@server-1 "echo $FIRST >> recu.txt"
ssh -i ~/.ssh/xnet xnet@server-1 "echo $LAST >> recu.txt"

requete()
{
	echo -e "$VERT""Envoi dune nouvelle requete à $SERVEUR$NORMAL"
	./getLogs.sh $SERVEUR $CURRENT $PAS &
	CURRENT=$(($CURRENT+$PAS+1))
}

checkServeur()
{
	echo -e "$ROUGE""Check de serveur$1$NORMAL"
	SERVEUR=$(echo 'server'$1)
	#ssh -i ~/.ssh/xnet xnet@$SERVEUR "mkdir /tmp/logs_tf"
	#LOGS_PRESENT=$(ssh -i ~/.ssh/xnet xnet@$SERVEUR "ls /tmp/logs_tf")

	# Vérification si le dossier /tmp/logs_tf est vide
	#if [ -z $LOGS_PRESENT ]
	if [ true ]
		then
		# Dossier vide, on envoi une nouvelle requete
		requete
		#echo 'rien'
	fi
}

while [ $CURRENT -lt $LAST ]
do
	checkServeur 1
	checkServeur 2
	checkServeur 3
	#echo $LOGS_PRESENT
	echo ''

done