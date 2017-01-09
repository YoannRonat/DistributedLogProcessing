#!/bin/bash

# Ce script télécharge un log passé en argument

echohelp()
{
	echo 'Utilisation : ./getLog.sh <log_number>'
}

if [ $# != 1 ]
	then
	echo 'Erreur : Nombre darguments invalides'
	echohelp
	exit 1
fi

mkdir /tmp/logs_tf
wget --quiet -P /tmp/logs_tf http://logs.tf/logs/log_$1.log.zip
# Permet de s'assurer que TOUS les logs souhaités soient téléchatgés
SUCCESS=$?
while [ $SUCCESS -ne "0" ]
do
	wget --quiet -P /tmp/logs_tf http://logs.tf/logs/log_$1.log.zip
	SUCCESS=$?
done
unzip -o /tmp/logs_tf/log_$1.log.zip -d /tmp/logs_tf/
rm /tmp/logs_tf/log_$1.log.zip
