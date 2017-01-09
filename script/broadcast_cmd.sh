usage()
{
	echo 'Utilisation : ./broadcast_cmd.sh "<commande>"'
}

if [ $# != 1 ]
	then
	echo "Erreur : Nombre d'argument invalide"
	usage
	exit 1
fi


broadcast() {
	# Lancement du master
	echo -e "$VERT" "Lancement de la commande sur server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "$2"
	echo -e "$VERT" "Lancement de la commande sur server-"$1" [OK]" "$NORMAL"
}

broadcast "1" "$1" & broadcast "2" "$1" & broadcast "3" "$1" & wait