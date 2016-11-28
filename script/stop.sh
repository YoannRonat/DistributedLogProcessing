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


	# Elasticsearch starting
	echo -e "$VERT" "Elasticsearch starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service elasticsearch stop 2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch started on server-"$num"  [OK]" "$NORMAL"

	# Kibana starting
	echo -e "$VERT" "Kibana starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service kibana stop 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana started on server-"$num"  [OK]" "$NORMAL"


	# Nginx starting
	echo -e "$VERT" "Nginx starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service nginx stop 2>&1"$end_cmd""
	echo -e "$VERT" "Nginx started on server-"$num"  [OK]" "$NORMAL"

	# Logstash starting
	echo -e "$VERT" "Logstash starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service logstash stop 2>&1"$end_cmd""
	echo -e "$VERT" "Logstash started on server-"$num"  [OK]" "$NORMAL"

	# Loading Filebeat
	echo -e "$VERT" "Filebeat starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service filebeat stop"$end_cmd""
	echo -e "$VERT" "Filebeat started on server-"$num"  [OK]" "$NORMAL"
}


################# TOOLS INSTALLATION ON SERVER-1 #################

stop_stack 

################# DEPLOYMENT ON SERVER-2 #################

stop_stack "2"

################## DEPLOYMENT ON SERVER-3 #################

stop_stack "3"
