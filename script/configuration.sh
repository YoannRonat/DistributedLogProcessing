#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definition ###################

configuration_stack () {

	# Elasticsearch configuration
	echo -e "$VERT" "Elasticsearch configuration on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/elasticsearch/elasticsearch.yml https://gist.githubusercontent.com/trussello/d401cf10782e3d42670d5ca4ced7dc53/raw/7a8cf2340adb136b690279117b576b3b85e2d3a5/elasticsearch.yml > /dev/null"
	echo -e "$VERT" "Elasticsearch configuration on server-"$1"  [OK]" "$NORMAL"

	# Kibana configuration
	echo -e "$VERT" "Kibana configuration on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /opt/kibana/config/kibana.yml  https://gist.githubusercontent.com/trussello/0a4d0f4aad20b0edcae7b9ee141a2b06/raw/afa7d55d3069c5f2e0c84348b086251718974d17/kibana.yml > /dev/null"
	echo -e "$VERT" "Kibana configuration on server-"$1"  [OK]" "$NORMAL"

	# Nginx configuration
	echo -e "$VERT" "Nginx configuration on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo htpasswd -c -b /etc/nginx/htpasswd.users kibanasdtd kibana123 > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/nginx/sites-available/default https://gist.github.com/trussello/647af94e87290f4eca16c83fa08929d9/raw > /dev/null"
	echo -e "$VERT" "Nginx configuration on server-"$1"  [OK]" "$NORMAL"


	# Logstash configuration
	echo -e "$VERT" "Logstash configuration on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/pki/tls/certs > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/pki/tls/private > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "cd /etc/pki/tls; sudo openssl req -subj '/CN=localhost/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt > /dev/null;cd"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/logstash/conf.d/02-beats-input.conf https://gist.github.com/trussello/b44264fe9a1616f51a21f2ef4baec9bb/raw > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/logstash/conf.d/10-syslog-filter.conf https://gist.githubusercontent.com/trussello/16662bc7d036b03c3616fbbfeb045398/raw/3156b12afa48edfe4006b79a70c46f7df948afd7/10-syslog-filter.conf > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo mkdir -p /etc/logstash/conf.d/patterns > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/logstash/conf.d/patterns/pattern https://gist.githubusercontent.com/trussello/52276d1ec08a7236bf205ee2629484d0/raw/c641c2f2c38674c93b9d89cc0eec1d2388444a6e/pattern > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/logstash/conf.d/30-elasticsearch-output.conf https://gist.githubusercontent.com/trussello/aa3da75b1203f87f6bd5b1deb5a7bcf1/raw/689741043c51d001e43537d11ec7d2cab38212d8/30-elasticsearch-output.conf > /dev/null"
	echo -e "$VERT" "Logstash configuration on server-"$1"  [OK]" "$NORMAL"


	# Loading Kibana Dashboards
	echo -e "$VERT" "Kibana configuration on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "unzip beats-dashboards-*.zip > /dev/null"
	echo -e "$VERT" "Kibana configuration on server-"$1"  [OK]" "$NORMAL"

	# Loading Filebeat Index Template in Elasticsearch
	echo -e "$VERT" "Loading Filebeat Index Template in Elasticsearch on server-"$1"" "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json > /dev/null"
	echo -e "$VERT" "Loaded Filebeat Index Template in Elasticsearch on server-"$1" [OK]" "$NORMAL"


	# Filebeat configuration on server-1
	echo -e "$VERT" "Filebeat Configuration on server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/filebeat/filebeat.yml https://gist.githubusercontent.com/trussello/74b8312a0435981c83dd543f841a459a/raw/f427723e85b2f30564db37a9b523b4c6c76b8e15/filebeat.yml > /dev/null"
	echo -e "$VERT" "Filebeat Configuration on server-"$1" [OK]" "$NORMAL"

	# Monit configuration
	echo -e "$VERT" "Monit Configuration on server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O /etc/monit/monitrc https://gist.githubusercontent.com/trussello/121acba2aaabdd675ee19d9b86224fb5/raw/da24136e8b75755f37a438c77d8300253da23e42/monitrc > /dev/null"
	echo -e "$VERT" "Monit Configuration on server-"$1" [OK]" "$NORMAL"

	# ZooKeeper configuration
	zooDir="zookeeper"
	zooArchName="zookeeper-3.4.9.tar.gz"
	
	echo -e "$VERT" "ZooKeeper Configuration on server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo wget -O ~/"$zooDir"/conf/zoo.cfg https://gist.githubusercontent.com/trussello/6c906bd8e869c222a49cece300322eaa/raw/968d55e6fb68c64088151cdd51eb133350519f88/zoo.cfg > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sed -i 's/server-"$1":/0.0.0.0:/' ~/"$zooDir"/conf/zoo.cfg > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo '$1' > ~/zookeeper/data/myid"
	echo -e "$VERT" "ZooKeeper Configuration on server-"$1" [OK]" "$NORMAL"
}

################# CONFIGURATION ON ON ALL SERVERS ###################

configuration_stack "1" & configuration_stack "2" & configuration_stack "3" & wait
