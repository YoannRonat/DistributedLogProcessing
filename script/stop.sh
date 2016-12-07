#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


################# Function definition ###################

stop_stack () {
	
	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"


	# Elasticsearch stopping
	echo -e "$VERT" "Elasticsearch stopping on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl stop elasticsearch.service 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl disable elasticsearch.service 2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch stopped on server-"$num"  [OK]" "$NORMAL"

	# Kibana stopping
	echo -e "$VERT" "Kibana stopping on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl stop kibana.service 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl disable kibana.service 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana stopped on server-"$num"  [OK]" "$NORMAL"


	# Nginx stopping
	echo -e "$VERT" "Nginx stopping on server-"$num" ..." "$NORMAL"*
	eval ""$cmd"sudo systemctl stop nginx.service 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl disable nginx.service 2>&1"$end_cmd""
	echo -e "$VERT" "Nginx stopped on server-"$num"  [OK]" "$NORMAL"

	# Logstash stopping
	echo -e "$VERT" "Logstash stopping on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl stop logstash.service 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl disable logstash.service 2>&1"$end_cmd""
	echo -e "$VERT" "Logstash stopped on server-"$num"  [OK]" "$NORMAL"

	# Filebeat stopping
	echo -e "$VERT" "Filebeat stopping on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo systemctl stop filebeat.service 2>&1"$end_cmd""
	eval ""$cmd"sudo systemctl disable filebeat.service 2>&1"$end_cmd""
	echo -e "$VERT" "Filebeat stopped on server-"$num"  [OK]" "$NORMAL"

	eval ""$cmd"sudo systemctl reset-failed 2>&1"$end_cmd""
}


################# TOOLS INSTALLATION ON SERVER-1 #################

stop_stack 

################# DEPLOYMENT ON SERVER-2 #################

stop_stack "2"

################## DEPLOYMENT ON SERVER-3 #################

stop_stack "3"
