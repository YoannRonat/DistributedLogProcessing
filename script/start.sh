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


	# Elasticsearch starting
	echo -e "$VERT" "Elasticsearch starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service elasticsearch restart 2>&1"$end_cmd""
	eval ""$cmd"sudo update-rc.d elasticsearch defaults 95 10 2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch started on server-"$num"  [OK]" "$NORMAL"

	# Kibana starting
	echo -e "$VERT" "Kibana starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo update-rc.d kibana defaults 96 9 2>&1"$end_cmd""
	eval ""$cmd"sudo service kibana start 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana started on server-"$num"  [OK]" "$NORMAL"


	# Nginx starting
	echo -e "$VERT" "Nginx starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service nginx restart 2>&1"$end_cmd""
	echo -e "$VERT" "Nginx started on server-"$num"  [OK]" "$NORMAL"

	# Logstash starting
	echo -e "$VERT" "Logstash starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service logstash configtest 2>&1"$end_cmd""
	eval ""$cmd"sudo service logstash restart 2>&1"$end_cmd""
	eval ""$cmd"sudo update-rc.d logstash defaults 96 9 2>&1"$end_cmd""
	echo -e "$VERT" "Logstash started on server-"$num"  [OK]" "$NORMAL"

	# Loading Filebeat
	echo -e "$VERT" "Filebeat starting on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo service filebeat restart"$end_cmd""
	eval ""$cmd"sudo update-rc.d filebeat defaults 95 10"$end_cmd""
	echo -e "$VERT" "Filebeat started on server-"$num"  [OK]" "$NORMAL"
}


################# TOOLS INSTALLATION ON SERVER-1 #################

start_stack 

################# DEPLOYMENT ON SERVER-2 #################

start_stack "2"

################## DEPLOYMENT ON SERVER-3 #################

start_stack "3"
