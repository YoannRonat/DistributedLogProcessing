#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definitions ###################

configuration_stack () {

	# Elasticsearch configuration
	echo -e "$VERT" "Elasticsearch configuration on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml > /dev/null"
	echo -e "$VERT" "Elasticsearch configuration on server-"$1"  [OK]" "$NORMAL"

	# Kibana configuration
	echo -e "$VERT" "Kibana configuration on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/kibana.yml /opt/kibana/config/kibana.yml > /dev/null"
	echo -e "$VERT" "Kibana configuration on server-"$1"  [OK]" "$NORMAL"

	# Nginx configuration
	echo -e "$VERT" "Nginx configuration on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo htpasswd -c -b /etc/nginx/htpasswd.users kibanasdtd kibana123 > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/default_nginx /etc/nginx/sites-available/default > /dev/null"
	echo -e "$VERT" "Nginx configuration on server-"$1"  [OK]" "$NORMAL"


	# Logstash configuration
	echo -e "$VERT" "Logstash configuration on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/pki/tls/certs > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/pki/tls/private > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "cd /etc/pki/tls; sudo openssl req -subj '/CN=localhost/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt > /dev/null;cd"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/10-syslog-filter.conf /etc/logstash/conf.d/10-syslog-filter.conf > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/logstash/conf.d/patterns > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/pattern /etc/logstash/conf.d/patterns/pattern > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf  > /dev/null"
	echo -e "$VERT" "Logstash configuration on server-"$1"  [OK]" "$NORMAL"


	# Loading Kibana Dashboards
	echo -e "$VERT" "Kibana configuration on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "unzip beats-dashboards-*.zip > /dev/null"
	echo -e "$VERT" "Kibana configuration on server-"$1"  [OK]" "$NORMAL"

	# Loading Filebeat Index Template in Elasticsearch
	echo -e "$VERT" "Loading Filebeat Index Template in Elasticsearch on server-"$1"" "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json > /dev/null"
	echo -e "$VERT" "Loaded Filebeat Index Template in Elasticsearch on server-"$1" [OK]" "$NORMAL"


	# Filebeat configuration on server-1
	echo -e "$VERT" "Filebeat Configuration on server-"$1"..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/filebeat.yml /etc/filebeat/filebeat.yml > /dev/null"
	echo -e "$VERT" "Filebeat Configuration on server-"$1" [OK]" "$NORMAL"

	# Monit configuration
	echo -e "$VERT" "Monit Configuration on server-"$1"..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/monitrc /etc/monit/monitrc > /dev/null"
	echo -e "$VERT" "Monit Configuration on server-"$1" [OK]" "$NORMAL"

	# ZooKeeper configuration
	zooDir="zookeeper"
	zooArchName="zookeeper-3.4.9.tar.gz"
	
	echo -e "$VERT" "ZooKeeper Configuration on server-"$1"..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo cp ~/resources/zoo.cfg ~/"$zooDir"/conf/zoo.cfg > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sed -i 's/server-"$1":/0.0.0.0:/' ~/"$zooDir"/conf/zoo.cfg > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "echo '$1' > ~/zookeeper/data/myid"
	echo -e "$VERT" "ZooKeeper Configuration on server-"$1" [OK]" "$NORMAL"
}

################# CONFIGURATION ON ON ALL SERVERS ###################

configuration_stack "1" & configuration_stack "2" & configuration_stack "3" & wait
