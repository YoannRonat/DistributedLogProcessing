#!/bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

zooDir="zookeeper"

usage()
{
	echo 'Utilisation : ./zookeeper_start.sh <numero de la machine>'
}

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


if [ $# -gt 1 ]
	then
	echo "Erreur : Nombre d'argument invalide"
	usage
	exit 1
fi

num=`cat /home/xnet/zookeeper/data/myid`

if [ $# -eq 1 ]
	then
	num="$1"
fi

zookeeper_start_server "$num" & sleep 5 
zookeeper_start_master "$num" & sleep 5
zookeeper_start_worker "$num" &