#!/bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

zooDir="zookeeper"

zookeeper_configuration() {
	
	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"
	
	# Svn installation
	# TODO : A mettre dans install.sh
	echo -e "$VERT" "Subversion installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo apt-get -y install subversion"$end_cmd""
	echo -e "$VERT" "Subversion installation on server-"$num" [OK]" "$NORMAL"
	
	# Zookeeper-master-worker installation
	# TODO : A mettre dans install.sh
	echo -e "$VERT" "Zookeeper-master-worker installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo rm -rf zookeeper-master-worker"$end_cmd""
	eval ""$cmd"svn checkout https://github.com/YoannRonat/DistributedLogProcessing/trunk/zookeeper-master-worker"$end_cmd""
	echo -e "$VERT" "Zookeeper-master-worker installation on server-"$num" [OK]" "$NORMAL"
	
	# Maven installation
	# TODO : A mettre dans install.sh
	echo -e "$VERT" "Maven installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo apt-get -y install maven"$end_cmd""
	echo -e "$VERT" "Maven installation on server-"$num" [OK]" "$NORMAL"
	
	# Zookeeper-master-worker compilation
	# TODO : A mettre dans install.sh
	echo -e "$VERT" "Zookeeper-master-worker installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"cd zookeeper-master-worker && mvn install && cd"$end_cmd""
	echo -e "$VERT" "Zookeeper-master-worker installation on server-"$num" [OK]" "$NORMAL"
	
	
}

# Zookeeper-master-worker execution
# TODO : A mettre dans start.sh

zookeeper_start_master() {
	
	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"

	
	# Lancement du daemon zookeeper sur le master
	eval ""$cmd"sudo $zooDir/bin/zkServer.sh start"$end_cmd""
	eval ""$cmd"sleep 5"$end_cmd""
	echo -e "$VERT" "Lancement du Master-Worker sur server-"$num"..." "$NORMAL"
	eval ""$cmd"cd zookeeper-master-worker && java -cp .:/home/xnet/zookeeper/zookeeper-3.4.9.jar:/home/xnet/zookeeper/lib/slf4j-api-1.6.1.jar:/home/xnet/zookeeper/lib/slf4j-log4j12-1.6.1.jar:/home/xnet/zookeeper/lib/log4j-1.2.16.jar:/home/xnet/zookeeper-master-worker/target/ZooKeeper-Book-0.0.1-SNAPSHOT.jar org.apache.zookeeper.book.Master server-1:2181 &"$end_cmd""
	echo -e "$VERT" "Lancement du Master-Worker sur server-"$num" [OK]" "$NORMAL"
}

zookeeper_start_worker() {

	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"

	echo -e "$VERT" "Lancement du Master-Worker sur server-"$num"..." "$NORMAL"
	eval ""$cmd"cd zookeeper-master-worker && java -cp .:/home/xnet/zookeeper/zookeeper-3.4.9.jar:/home/xnet/zookeeper/lib/slf4j-api-1.6.1.jar:/home/xnet/zookeeper/lib/slf4j-log4j12-1.6.1.jar:/home/xnet/zookeeper/lib/log4j-1.2.16.jar:/home/xnet/zookeeper-master-worker/target/ZooKeeper-Book-0.0.1-SNAPSHOT.jar org.apache.zookeeper.book.Worker server-1:2181"$end_cmd""
	echo -e "$VERT" "Lancement du Master-Worker sur server-"$num" [OK]" "$NORMAL"
}

zookeeper_configuration "1" & zookeeper_configuration "2" & zookeeper_configuration "3" & wait

zookeeper_start_master "1"

zookeeper_start_worker "2" &
zookeeper_start_worker "3" &

# cd
# ./zookeeper/bin/zkServer.sh
# java -cp .:/home/xnet/zookeeper/zookeeper-3.4.9.jar:/home/xnet/zookeeper/lib/slf4j-api-1.6.1.jar:/home/xnet/zookeeper/lib/slf4j-log4j12-1.6.1.jar:/home/xnet/zookeeper/lib/log4j-1.2.16.jar:/home/xnet/zookeeper-book-example/target/ZooKeeper-Book-0.0.1-SNAPSHOT.jar org.apache.zookeeper.book.Worker server-1:2181
