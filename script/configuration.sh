#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definition ###################

configuration_stack () {

	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"

	# Elasticsearch configuration
	echo -e "$VERT" "Elasticsearch configuration on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo wget -O /etc/elasticsearch/elasticsearch.yml https://gist.githubusercontent.com/trussello/d401cf10782e3d42670d5ca4ced7dc53/raw"$end_cmd""
	echo -e "$VERT" "Elasticsearch configuration on server-"$num"  [OK]" "$NORMAL"

	# Kibana configuration
	echo -e "$VERT" "Kibana configuration on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo wget -O /opt/kibana/config/kibana.yml  https://gist.github.com/trussello/0a4d0f4aad20b0edcae7b9ee141a2b06/raw 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana configuration on server-"$num"  [OK]" "$NORMAL"

	# Nginx configuration
	echo -e "$VERT" "Nginx configuration on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo htpasswd -c -b /etc/nginx/htpasswd.users kibanasdtd kibana123 2>&1"$end_cmd""
	eval ""$cmd"sudo wget -O /etc/nginx/sites-available/default https://gist.github.com/trussello/647af94e87290f4eca16c83fa08929d9/raw "$end_cmd""
	echo -e "$VERT" "Nginx configuration on server-"$num"  [OK]" "$NORMAL"


	# Logstash configuration
	echo -e "$VERT" "Logstash configuration on server-"$num" ..." "$NORMAL"
	eval ""$cmd"sudo mkdir -p /etc/pki/tls/certs 2>&1"$end_cmd""
	eval ""$cmd"sudo mkdir -p /etc/pki/tls/private 2>&1"$end_cmd""
	eval ""$cmd"cd /etc/pki/tls; sudo openssl req -subj '/CN=localhost/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt 2>&1;cd"$end_cmd""
	eval ""$cmd"sudo wget -O /etc/logstash/conf.d/02-beats-input.conf https://gist.github.com/trussello/b44264fe9a1616f51a21f2ef4baec9bb/raw"$end_cmd""
	eval ""$cmd"sudo wget -O /etc/logstash/conf.d/10-syslog-filter.conf https://gist.github.com/trussello/16662bc7d036b03c3616fbbfeb045398/raw"$end_cmd""
	eval ""$cmd"sudo wget -O /etc/logstash/conf.d/30-elasticsearch-output.conf https://gist.github.com/trussello/aa3da75b1203f87f6bd5b1deb5a7bcf1/raw"$end_cmd""
	echo -e "$VERT" "Logstash configuration on server-"$num"  [OK]" "$NORMAL"


	# Loading Kibana Dashboards
	echo -e "$VERT" "Kibana configuration on server-"$num" ..." "$NORMAL"
	eval ""$cmd"curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip 2>&1"$end_cmd""
	eval ""$cmd"unzip beats-dashboards-*.zip 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana configuration on server-"$num"  [OK]" "$NORMAL"

	# Loading Filebeat Index Template in Elasticsearch
	echo -e "$VERT" "Loading Filebeat Index Template in Elasticsearch on server-"$num"" "$NORMAL"
	eval ""$cmd"curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json 2>&1"$end_cmd""
	eval ""$cmd"curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json 2>&1"$end_cmd""
	echo -e "$VERT" "Loaded Filebeat Index Template in Elasticsearch on server-"$num" [OK]" "$NORMAL"


	# Filebeat configuration on server-1
	echo -e "$VERT" "Filebeat Configuration on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo wget -O /etc/filebeat/filebeat.yml https://gist.githubusercontent.com/Erennor/f13ad8b08a2351306de8ec3f4d695984/raw/66ea5c018d029f7c2ac4d014562c58752d7ed50e/filebeat.yml"$end_cmd""
	echo -e "$VERT" "Filebeat Configuration on server-"$num" [OK]" "$NORMAL"

	# Monit configuration
	echo -e "$VERT" "Monit Configuration on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo wget -O /etc/monit/monitrc https://gist.githubusercontent.com/assoulid/c14335994d31ac2aaafebd8e0667e038/raw/563243e879e21d2916a6eb2279c55e7af6121729/monitrc 2>&1"$end_cmd""
	echo -e "$VERT" "Monit Configuration on server-"$num" [OK]" "$NORMAL"

	# ZooKeeper configuration
	zooDir="zookeeper"
	zooArchName="zookeeper-3.4.9.tar.gz"
	
	echo -e "$VERT" "ZooKeeper Configuration on server-"$num"..." "$NORMAL"
	eval ""$cmd"sudo wget -O ~/"$zooDir"/conf/zoo.cfg https://gist.githubusercontent.com/Erennor/d67fa0247f607c1fdb3256904804b7dd/raw/2abe981954569927a1db6842d6a6865ba6afe849/zoo.cfg"$end_cmd""
	echo -e "$VERT" "ZooKeeper Configuration on server-"$num" [OK]" "$NORMAL"
}

################# DEPLOYMENT ON SERVER-1 #################
configuration_stack

################# DEPLOYMENT ON SERVER-2 #################
configuration_stack "2"


################# DEPLOYMENT ON SERVER-3 #################
configuration_stack "3"
