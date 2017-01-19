#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


################# Function definitions ###################

stop_stack () {
	
	# Elasticsearch stopping
	echo -e "$VERT" "Elasticsearch stopping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop elasticsearch.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable elasticsearch.service > /dev/null"
	echo -e "$VERT" "Elasticsearch stopped on server-"$1"  [OK]" "$NORMAL"

	# Kibana stopping
	echo -e "$VERT" "Kibana stopping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop kibana.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable kibana.service > /dev/null"
	echo -e "$VERT" "Kibana stopped on server-"$1"  [OK]" "$NORMAL"


	# Nginx stopping
	echo -e "$VERT" "Nginx stopping on server-"$1" ..." "$NORMAL"*
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop nginx.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable nginx.service > /dev/null"
	echo -e "$VERT" "Nginx stopped on server-"$1"  [OK]" "$NORMAL"

	# Logstash stopping
	echo -e "$VERT" "Logstash stopping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop logstash.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable logstash.service > /dev/null"
	echo -e "$VERT" "Logstash stopped on server-"$1"  [OK]" "$NORMAL"

	# Filebeat stopping
	echo -e "$VERT" "Filebeat stopping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop filebeat.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable filebeat.service > /dev/null"
	echo -e "$VERT" "Filebeat stopped on server-"$1"  [OK]" "$NORMAL"

	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl reset-failed > /dev/null"

	# Stoping M/Monit
	echo -e "$VERT" "M/Monit stoping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo ~/mmonit-3.6.2/bin/mmonit stop > /dev/null"
	echo -e "$VERT" "M/Monit stopped on server-"$1"  [OK]" "$NORMAL"

	# Stoping Monit
	echo -e "$VERT" "Monit stoping on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl stop monit.service > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl disable monit.service > /dev/null"
	echo -e "$VERT" "Monit stopped on server-"$1"  [OK]" "$NORMAL"

	ssh -i ~/.ssh/xnet xnet@server-"$1" "ps ax | grep -E '(kibana|nginx|elasticsearch|filebeat|logstash|java|getLog.sh|monit|apt)' | awk -F ' ' '{print \$1}' | xargs sudo kill -9 > /dev/null"

}

################# STOPPING STACK ON ALL SERVERS ###################

stop_stack "1" & stop_stack "2" & stop_stack "3" & wait
