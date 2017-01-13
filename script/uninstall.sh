#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


################# Function definition ###################

uninstall_stack() {

	#ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo pkill kibana; sudo pkill nginx; sudo pkill elasticsearch; sudo pkill filebeat; sudo pkill logstash; sudo pkill java > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "ps ax | grep -E '(kibana|nginx|elasticsearch|filebeat|logstash|java)' | awk -F ' ' '{print \$1}' | xargs sudo kill -9 > /dev/null"
	# Remove cache
	echo -e "$VERT" "Removing cache on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo rm -rf /var/lib/elasticsearch/ /etc/elasticsearch /etc/filebeat /etc/logstash \
	/opt/kibana /etc/apt/sources.list.d/* /var/log/logstash \
	/etc/monit /var/monit /var/lib/logstash /var/lib/kibana /var/lib/nginx /var/lib/filebeat > /dev/null"
	echo -e "$VERT" "Cache removed on server-"$1"  [OK]" "$NORMAL"

	# Elasticsearch uninstallation
	echo -e "$VERT" "Elasticsearch uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get -y remove --purge elasticsearch > /dev/null"
	echo -e "$VERT" "Elasticsearch uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Kibana uninstallation
	echo -e "$VERT" "Kibana uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get -y remove --purge kibana > /dev/null"
	echo -e "$VERT" "Kibana uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Nginx uninstallation
	echo -e "$VERT" "Nginx uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get remove --purge nginx apache2-utils > /dev/null"
	echo -e "$VERT" "Nginx uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Logstash uninstallation
	echo -e "$VERT" "Logstash uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get remove --purge logstash > /dev/null"
	echo -e "$VERT" "Logstash uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Removing Kibana Dashboards
	echo -e "$VERT" "Kibana uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo rm -rf beats-dashboards-* > /dev/null"
	echo -e "$VERT" "Kibana uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Filebeat uninstallation
	echo -e "$VERT" "Filebeat Package uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get remove --purge filebeat > /dev/null"
	echo -e "$VERT" "Filebeat Package uninstallation on server-"$1"  [OK]" "$NORMAL"

	ssh -i  ~/.ssh/xnet xnet@server-"$1" "rm ~/filebeat-index-template.json > /dev/null"

	# M/Monit uninstallation
	echo -e "$VERT" "M/Monit uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo rm -rf ~/mmonit-3.6.2 > /dev/null"
	echo -e "$VERT" "M/Monit uninstallation on server-"$1"  [OK]" "$NORMAL"

	# Monit uninstallation
	echo -e "$VERT" "Monit uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get remove --purge monit > /dev/null"
	echo -e "$VERT" "Monit uninstallation on server-"$1"  [OK]" "$NORMAL"
	
	# ZooKeeper uninstallation
	echo -e "$VERT" "ZooKeeper uninstallation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo rm -rf ~/zookeeper > /dev/null"
	echo -e "$VERT" "ZooKeeper uninstallation  on server-"$1"  [OK]" "$NORMAL"

	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get autoremove > /dev/null"
}

./stop.sh

################# DEPLOYMENT ON SERVER-3 #################
uninstall_stack "3" & uninstall_stack "2" & uninstall_stack "1" & wait

for (( i = 3; i >= 1; i-- )); do
	ssh -i ~/.ssh/xnet xnet@server-"$i" "sudo wget -O /etc/hosts https://gist.github.com/trussello/4489d8508b73193a2b06fad1a7d0735e/raw > /dev/null" &
done

