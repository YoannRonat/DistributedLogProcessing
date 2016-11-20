#!/bin/bash

# Script d'exécution de la machine OVH
# utilisation : ./getLogs.sh <serveur> <logNumber> <pas>
# la machine <serveur> va alors télécharger les logs <logNumber> à <logNumber> + <pas>

int='^[0-9]+$'
SERVEUR=$1
LOGNUMBER=$2
PAS=$3
LAST=$(($LOGNUMBER+$PAS))

serveur1="149.202.167.70"
serveur2="149.202.167.72"
serveur3="149.202.167.66"

echohelp()
{
	echo 'Utilisation : ./getLogs.sh <serveur> <logNumber> <pas>'
	echo 'Possibiltés pour <serveur> : serveur1, serveur2, serveur3'
}

if [ $# != 3 ]
	then
	echo 'Erreur : Nombre darguments invalides'
	echohelp
	exit 1
fi

if [ $1 != "serveur1" ] && [ $1 != "serveur2" ] && [ $1 != "serveur3" ]
	then
	echo 'Erreur : mauvais arguments'
	echohelp
	exit 1
fi

if ! [[ $2 =~ $int ]] || ! [[ $3 =~ $int ]]
	then
	echo 'Erreur : Les arguments 2 et 3 doivent être des entiers'
	echo "valeurs lues : arg2 = $2 et arg3 = $3"
	echohelp
	exit 1
fi

if [ $1 = "serveur1" ]
	then
	SERVEUR=$serveur1
elif [ $1 = "serveur2" ]
	then
	SERVEUR=$serveur2
elif [ $1 = "serveur3" ]
	then
	SERVEUR=$serveur3
fi

# Le script de téléchargement des logs est exécuté sur la machine esclave
ssh -i ~/.ssh/xnet xnet@$SERVEUR "sh logDl.sh $LOGNUMBER $LAST" &
