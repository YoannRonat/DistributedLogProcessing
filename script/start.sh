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
	eval ""$cmd"sudo service monit restart 2>&1"$end_cmd""
	echo -e "$VERT" "Monit started on server-"$num"  [OK]" "$NORMAL"
}


################# TOOLS INSTALLATION ON SERVER-1 #################

start_stack 

################# DEPLOYMENT ON SERVER-2 #################

start_stack "2"

################## DEPLOYMENT ON SERVER-3 #################

start_stack "3"
