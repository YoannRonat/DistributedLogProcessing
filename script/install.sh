#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"

# Hosts configurations
echo -e "$VERT" "Hosts configurations..." "$NORMAL"
sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost server-1\n149.202.167.72 server-2\n149.202.167.66 server-3/g' /etc/hosts 2>&1
echo -e "$VERT" "Hosts configurations [OK]" "$NORMAL"

# Java installation
echo -e "$VERT" "Java installation..." "$NORMAL"
sudo add-apt-repository -y ppa:webupd8team/java 2>&1
sudo apt-get update 2>&1
sudo apt-get -y install oracle-java8-installer 2>&1
echo -e "$VERT" "Java installation [OK]" "$NORMAL"

# Elasticsearch installation
echo -e "$VERT" "Elasticsearch installation..." "$NORMAL"
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list 2>&1
sudo apt-get update 2>&1
sudo apt-get -y install elasticsearch 2>&1
sudo sed -i 's/# network.*/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml 2>&1
sudo service elasticsearch restart 2>&1
sudo update-rc.d elasticsearch defaults 95 10 2>&1
echo -e "$VERT" "Elasticsearch installation [OK]" "$NORMAL"

# Kibana installation
echo -e "$VERT" "Kibana installation..." "$NORMAL"
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list 2>&1 2>&1
sudo apt-get update 2>&1
sudo apt-get -y install kibana 2>&1
sudo sed -i 's/# server\.host.*/server.host: "localhost"/g' /opt/kibana/config/kibana.yml 2>&1
sudo update-rc.d kibana defaults 96 9 2>&1
sudo service kibana start 2>&1
echo -e "$VERT" "Kibana installation [OK]" "$NORMAL"


# Nginx installation
echo -e "$VERT" "Nginx installation..." "$NORMAL"
sudo apt-get install nginx apache2-utils 2>&1
sudo htpasswd -c -b /etc/nginx/htpasswd.users kibanasdtd kibana123 2>&1
(
cat <<"EOF"
server {
	listen 80;

	server_name 149.202.167.70;

	auth_basic "Restricted Access";
	auth_basic_user_file /etc/nginx/htpasswd.users;

	location / {
	    proxy_pass http://localhost:5601;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection 'upgrade';
	    proxy_set_header Host $host;
	    proxy_cache_bypass $http_upgrade;        
	}
}
EOF
) | sudo tee /etc/nginx/sites-available/default 2>&1
sudo service nginx restart 2>&1
echo -e "$VERT" "Nginx installation [OK]" "$NORMAL"

# Logstash installation
echo -e "$VERT" "Logstash installation..." "$NORMAL"
echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list 2>&1
sudo apt-get update 2>&1
sudo apt-get install logstash 2>&1
sudo mkdir -p /etc/pki/tls/certs 2>&1
sudo mkdir /etc/pki/tls/private 2>&1
cd /etc/pki/tls; sudo openssl req -subj '/CN=server-1/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt 2>&1;cd
(
cat <<"EOF"
input {
      beats {
	port => 5044
	ssl => true
	ssl_certificate => "/etc/pki/tls/certs/logstash-forwarder.crt"
	ssl_key => "/etc/pki/tls/private/logstash-forwarder.key"
      }
}
EOF
) | sudo tee /etc/logstash/conf.d/02-beats-input.conf 2>&1
(
cat <<"EOF"
filter {
	if [type] == "syslog" {
		grok {
			match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
			add_field => [ "received_at", "%{@timestamp}" ]
			add_field => [ "received_from", "%{host}" ]
		}
		syslog_pri { }
		date {
			match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
		}
	}
}
EOF
) | sudo tee /etc/logstash/conf.d/10-syslog-filter.conf 2>&1
(
cat <<"EOF"
output {
	elasticsearch {
		hosts => ["localhost:9200"]
		sniffing => true
		manage_template => false
		index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
		document_type => "%{[@metadata][type]}"
	}
}
EOF
) | sudo tee /etc/logstash/conf.d/30-elasticsearch-output.conf 2>&1
sudo service logstash configtest 2>&1
sudo service logstash restart 2>&1
sudo update-rc.d logstash defaults 96 9 2>&1
echo -e "$VERT" "Logstash installation [OK]" "$NORMAL"

# Loading Kibana Dashboards
echo -e "$VERT" "Loading Kibana Dashboards..." "$NORMAL"
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip 2>&1
sudo apt-get -y install unzip 2>&1
unzip beats-dashboards-*.zip 2>&1
cd beats-dashboards-*; ./load.sh 2>&1; cd
echo -e "$VERT" "Kibana Dashboards loaded [OK]" "$NORMAL"

# Loading Filebeat Index Template in Elasticsearch
echo -e "$VERT" "Loading Filebeat Index Template in Elasticsearch" "$NORMAL"
curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json 2>&1
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json 2>&1
echo -e "$VERT" "Loaded Filebeat Index Template in Elasticsearch [OK]" "$NORMAL"

ssh -i ~/.ssh/xnet xnet@server-2 "sudo locale-gen fr_FR.UTF-8"

echo -e "$VERT" "Copying SSL Certificate to server-2" "$NORMAL"
scp -i ~/.ssh/xnet /etc/pki/tls/certs/logstash-forwarder.crt xnet@server-2:/tmp
echo -e "$VERT" "Copied SSL Certificate to server-2 [OK]" "$NORMAL"

# Hosts configurations on server-2
echo -e "$VERT" "Hosts configurations on server-2..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost server-2\n149.202.167.70 server-1\n149.202.167.66 server-3/g' /etc/hosts 2>&1"
echo -e "$VERT" "Hosts configurations on server-2[OK]" "$NORMAL"

echo -e "$VERT" "Filebeat Package installation on server-2..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo mkdir -p /etc/pki/tls/certs 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/ 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 'echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list 2>&1'
ssh -i ~/.ssh/xnet xnet@server-2 "wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo apt-get update 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo apt-get install filebeat 2>&1"
echo -e "$VERT" "Filebeat Package installation on server-2 [OK]" "$NORMAL"

# C'est un peu long à changer, peut être qu'on récupèra plutot le fichier config à chaque fois (donné en scp)
echo -e "$VERT" "Filebeat Configuration on server-2..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's#- /var/log/\*.log#- /var/log/syslog#g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/#document_type: log/document_type: syslog/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/elasticsearch:/#elasticsearch:/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/hosts: \[\"localhost:9200\"\]/#hosts: \[\"localhost:9200\"\]/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/#logstash:/logstash:/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/#hosts: \[\"localhost:5044\"\]/hosts: \[\"server-1:5044\"\]/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/#bulk_max_size: 2048/bulk_max_size: 1024/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/    #tls:/    tls:/g' /etc/filebeat/filebeat.yml 2>&1"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's*      #certificate_authorities: \[\"/etc/pki/root/ca.pem\"\]*      certificate_authorities: \[\"/etc/pki/tls/certs/logstash-forwarder.crt\"\]*g' /etc/filebeat/filebeat.yml 2>&1"
echo -e "$VERT" "Filebeat Configuration on server-2 [OK]" "$NORMAL"


ssh -i ~/.ssh/xnet xnet@server-2 "sudo service filebeat restart"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo update-rc.d filebeat defaults 95 10"



