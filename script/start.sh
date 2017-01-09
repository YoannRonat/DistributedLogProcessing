#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definition ###################

start_stack () {

	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"

	# Elasticsearch restarting
	echo -e "$VERT" "Elasticsearch restarting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl restart elasticsearch  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable elasticsearch  2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch restarted on server-"$num"  [OK]" "$NORMAL"

	# Kibana restarting
	echo -e "$VERT" "Kibana restarting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl restart kibana  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable kibana  2>&1"$end_cmd""
	echo -e "$VERT" "Kibana restarted on server-"$num"  [OK]" "$NORMAL"


	# Nginx restarting
	echo -e "$VERT" "Nginx restarting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl restart nginx  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable nginx  2>&1"$end_cmd""
	echo -e "$VERT" "Nginx restarted on server-"$num"  [OK]" "$NORMAL"

	# Logstash restarting
	echo -e "$VERT" "Logstash restarting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo /opt/logstash/bin/logstash --configtest -f /etc/logstash/conf.d/ 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl restart logstash  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable logstash  2>&1"$end_cmd""
	echo -e "$VERT" "Logstash restarted on server-"$num"  [OK]" "$NORMAL"

	# Loading Filebeat
	echo -e "$VERT" "Filebeat restarting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl restart filebeat  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable filebeat  2>&1"$end_cmd""
	echo -e "$VERT" "Filebeat restarted on server-"$num"  [OK]" "$NORMAL"

	eval ""$cmd"cd beats-dashboards-* && ./load.sh 2>&1 && cd"$end_cmd""

	# Loading M/Monit
	echo -e "$VERT" "M/Monit starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo ~/mmonit-3.6.2/bin/mmonit start 2>&1"$end_cmd""
	echo -e "$VERT" "M/Monit started on server-"$num"  [OK]" "$NORMAL"

	# Loading Monit
	echo -e "$VERT" "Monit starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl restart monit  2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl daemon-reload 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl enable monit  2>&1"$end_cmd""
	echo -e "$VERT" "Monit started on server-"$num"  [OK]" "$NORMAL"
}

zookeeper_start_master() {

	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"


	# Lancement du daemon zookeeper sur le master
	eval ""$cmd"sudo $zooDir/bin/zkServer.sh start"$end_cmd""

	echo -e "$VERT" "Lancement du Master-Worker sur server-"$num"..." "$NORMAL"
	eval ""$cmd"cd zookeeper-master-worker && java -cp .:/home/xnet/zookeeper/zookeeper-3.4.9.jar:/home/xnet/zookeeper/lib/slf4j-api-1.6.1.jar:/home/xnet/zookeeper/lib/slf4j-log4j12-1.6.1.jar:/home/xnet/zookeeper/lib/log4j-1.2.16.jar:/home/xnet/zookeeper-master-worker/target/ZooKeeper-Book-0.0.1-SNAPSHOT.jar org.apache.zookeeper.book.Master server-1:2181"$end_cmd""
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

################# STARTING STACK ON ALL SERVERS ###################

start_stack & start_stack "2" & start_stack "3" & wait
zookeeper_start_master "1" &
zookeeper_start_worker "2" & zookeeper_start_worker "3" & wait