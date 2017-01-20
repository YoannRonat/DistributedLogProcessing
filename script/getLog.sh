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

mkdir -p /tmp/logs_tf
sudo wget --quiet -P /tmp/logs_tf http://logs.tf/logs/log_"$1".log.zip
sudo unzip -o /tmp/logs_tf/log_"$1".log.zip -d /tmp/logs_tf/
sudo rm /tmp/logs_tf/log_"$1".log.zip
