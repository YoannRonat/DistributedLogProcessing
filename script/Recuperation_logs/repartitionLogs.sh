#!/bin/bash

# Script de répartition de téléchargement des logs entre les machines
# esclaves.

VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"

# Premier log de 2016
FIRST="1181650"
CURRENT=$FIRST
PAS="1"

serveur1="149.202.167.70"
serveur2="149.202.167.72"
serveur3="149.202.167.66"

requete()
{
	echo -e "$VERT""Envoi dune nouvelle requete à $SERVEUR$NORMAL"
	./getLogs.sh $SERVEUR $CURRENT $PAS &
	CURRENT=$(($CURRENT+$PAS))
}

checkServeur()
{
	echo -e "$ROUGE""Check de serveur$1$NORMAL"
	SERVEUR=$(echo 'serveur'$1)
	ssh -i ~/.ssh/xnet xnet@$SERVEUR "mkdir /tmp/logs_tf"
	LOGS_PRESENT=$(ssh -i ~/.ssh/xnet xnet@$SERVEUR "ls /tmp/logs_tf")

	# Vérification si le dossier /tmp/logs_tf est vide
	if [ -z $LOGS_PRESENT ]
		then
		# Dossier vide, on envoi une nouvelle requete
		requete
		#echo 'rien'
	fi
}

while [ true ]
do
	checkServeur 1
	checkServeur 2
	checkServeur 3
	echo $LOGS_PRESENT
	echo ''

done