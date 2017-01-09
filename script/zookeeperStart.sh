#!/bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

zooDir="zookeeper"

usage()
{
	echo 'Utilisation : ./zookeeperStart.sh <numero de la machine>'
}

if [ $# != 1 ]
	then
	echo "Erreur : Nombre d'argument invalide"
	usage
	exit 1
fi

zookeeper_start_server() {
	# Lancement du daemon zookeeper sur le master
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo "$zooDir"/bin/zkServer.sh start"
}


zookeeper_start_master() {
	# Lancement du master
	echo -e "$VERT" "Lancement du Master-Worker sur server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "java -cp /home/xnet/ZooKeeper-Book.jar org.apache.zookeeper.book.Master server-1:2181,server-2:2181,server-3:2181"
	echo -e "$VERT" "Lancement du Master-Worker sur server-"$1" [OK]" "$NORMAL"
}

zookeeper_start_worker() {
	# Lancement du worker
	echo -e "$VERT" "Lancement du Worker sur server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "java -cp /home/xnet/ZooKeeper-Book.jar org.apache.zookeeper.book.Worker server-1:2181,server-2:2181,server-3:2181"
	echo -e "$VERT" "Lancement du Worker sur server-"$1" [OK]" "$NORMAL"
}

################# STARTING ZOOKEEPER ON ALL MACHINES ###################
zookeeper_start_server "$1" & sleep 5 
zookeeper_start_master "$1" & sleep 5
zookeeper_start_worker "$1"