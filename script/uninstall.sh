#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


################# Function definition ###################

uninstall_stack() {
	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"

	pkill nginx; pkill kibana; pkill elasticsearch; pkill filebeat; pkill logstash
	# Remove cache
	echo -e "$VERT" "Removing cache on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo rm -rf /var/lib/elasticsearch/ /etc/elasticsearch /etc/filebeat /etc/logstash /opt/kibana /etc/apt/sources.list.d/* /var/log/logstash /var/lib/logstash"$end_cmd""
	eval ""$cmd"sudo wget -O /etc/hosts https://gist.github.com/trussello/4489d8508b73193a2b06fad1a7d0735e/raw"$end_cmd""
	echo -e "$VERT" "Cache removed on server-"$num"  [OK]" "$NORMAL"

	# Elasticsearch uninstallation
	echo -e "$VERT" "Elasticsearch uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get -y remove --purge elasticsearch 2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch uninstallation on server-"$num"  [OK]" "$NORMAL"

	# Kibana uninstallation
	echo -e "$VERT" "Kibana uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get -y remove --purge kibana 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana uninstallation on server-"$num"  [OK]" "$NORMAL"

	# Nginx uninstallation
	echo -e "$VERT" "Nginx uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get remove --purge nginx apache2-utils 2>&1"$end_cmd""
	echo -e "$VERT" "Nginx uninstallation on server-"$num"  [OK]" "$NORMAL"

	# Logstash uninstallation
	echo -e "$VERT" "Logstash uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get remove --purge logstash 2>&1"$end_cmd""
	echo -e "$VERT" "Logstash uninstallation on server-"$num"  [OK]" "$NORMAL"

	# Removing Kibana Dashboards
	echo -e "$VERT" "Kibana uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"rm -rf beats-dashboards-* 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana uninstallation on server-"$num"  [OK]" "$NORMAL"

	# Filebeat uninstallation
	echo -e "$VERT" "Filebeat Package uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get remove --purge filebeat 2>&1"$end_cmd""
	echo -e "$VERT" "Filebeat Package uninstallation on server-"$num"  [OK]" "$NORMAL"

	# ZooKeeper uninstallation
	echo -e "$VERT" "ZooKeeper uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"rm -rf ~/zookeeper"$end_cmd""
	echo -e "$VERT" "ZooKeeper uninstallation  on server-"$num"  [OK]" "$NORMAL"

	# M/Monit uninstallation
	echo -e "$VERT" "M/Monit uninstallation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"rm -rf ~/mmonit-3.6.2"$end_cmd""
	echo -e "$VERT" "M/Monit uninstallation  on server-"$num"  [OK]" "$NORMAL"

	eval ""$cmd"rm ~/filebeat-index-template.json 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get autoremove 2>&1"$end_cmd""
}

./stop.sh
################# DEPLOYMENT ON SERVER-3 #################
uninstall_stack "3"

################# DEPLOYMENT ON SERVER-2 #################
uninstall_stack "2"

################# DEPLOYMENT ON SERVER-1 #################
uninstall_stack
