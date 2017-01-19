#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definition ###################

installation_stack () {

	# Unzip installation
	echo -e "$VERT" "Unzip installation on server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get install unzip"
	echo -e "$VERT" "Unzip installation on server-"$1" [OK]" "$NORMAL"


	# Java installation
	echo -e "$VERT" "Java installation on server-"$1"..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo add-apt-repository -y ppa:webupd8team/java > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get update > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get -y install oracle-java8-installer > /dev/null"
	echo -e "$VERT" "Java installation on server-"$1" [OK]" "$NORMAL"

	# Elasticsearch installation
	echo -e "$VERT" "Elasticsearch installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo 'deb http://packages.elastic.co/elasticsearch/2.x/debian stable main' | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get update > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get -y install elasticsearch --allow-unauthenticated > /dev/null"
	echo -e "$VERT" "Elasticsearch installation on server-"$1"  [OK]" "$NORMAL"

	# Kibana installation
	echo -e "$VERT" "Kibana installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo 'deb http://packages.elastic.co/kibana/4.4/debian stable main' | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list > /dev/null > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get update > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get -y install kibana --allow-unauthenticated > /dev/null"
	echo -e "$VERT" "Kibana installation on server-"$1"  [OK]" "$NORMAL"


	# Nginx installation
	echo -e "$VERT" "Nginx installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get install nginx apache2-utils > /dev/null"
	echo -e "$VERT" "Nginx installation on server-"$1"  [OK]" "$NORMAL"

	# Logstash installation
	echo -e "$VERT" "Logstash installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get update > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get install logstash --allow-unauthenticated > /dev/null"
	echo -e "$VERT" "Logstash installation on server-"$1"  [OK]" "$NORMAL"

	# Filebeat installation
	echo -e "$VERT" "Filebeat Package installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "echo 'deb https://packages.elastic.co/beats/apt stable main' |  sudo tee -a /etc/apt/sources.list.d/beats.list > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get update > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "yes | sudo apt-get install filebeat --allow-unauthenticated > /dev/null"
	echo -e "$VERT" "Filebeat Package installation on server-"$1"  [OK]" "$NORMAL"

	# M/Monit Installation
	echo -e "$VERT" "M/Monit installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "tar -xzvf mmonit-3.6.2-linux-x64.tar.gz > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "rm mmonit-3.6.2-linux-x64.tar.gz > /dev/null"
	echo -e "$VERT" "M/Monit installation on server-"$1"  [OK]" "$NORMAL"

	# Monit Installation
	echo -e "$VERT" "Monit installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "sudo apt-get install -y monit > /dev/null"
	echo -e "$VERT" "Monit installation on server-"$1"  [OK]" "$NORMAL"

	# ZooKeeper Installation
	zooDir="zookeeper"
	zooArchName="zookeeper-3.4.9.tar.gz"

	echo -e "$VERT" "ZooKeeper installation on server-"$1" ..." "$NORMAL"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "wget http://apache.crihan.fr/dist/zookeeper/current/zookeeper-3.4.9.tar.gz > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "mkdir -p "$zooDir" && cd "$zooDir" && mkdir -p data && cd"

	ssh -i  ~/.ssh/xnet xnet@server-"$1" "tar -zxf $zooArchName -C $zooDir --strip-component 1 > /dev/null"
	ssh -i  ~/.ssh/xnet xnet@server-"$1" "rm "$zooArchName""
	echo -e "$VERT" "ZooKeeper installation on server-"$1"  [OK]" "$NORMAL"

	echo -e "$VERT" "Loading tools on server-"$1" ..." "$NORMAL"
	scp -i ~/.ssh/xnet ZooKeeper-Book.jar xnet@server-"$1":~
	scp -i ~/.ssh/xnet getLog.sh xnet@server-"$1":~
	scp -i ~/.ssh/xnet monit_zookeeper.sh xnet@server-"$1":~
	echo -e "$VERT" "Loaded tools on server-"$1"  [OK]" "$NORMAL"


}


#################  HOSTS CONFIGURATION ON SERVERS #################
echo -e "$VERT" "Hosts configurations..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@137.74.31.92 "sudo sed -i 's/127.0.0.1.*localhost/127.0.0.1 localhost server-1 server-4\n149.202.167.72 server-2\n149.202.167.66 server-3/g' /etc/hosts > /dev/null"
ssh -i ~/.ssh/xnet xnet@149.202.167.72 "sudo sed -i 's/127.0.0.1.*localhost/127.0.0.1 localhost server-2\n137.74.31.92 server-1\n149.202.167.66 server-3/g' /etc/hosts > /dev/null"
ssh -i ~/.ssh/xnet xnet@149.202.167.66 "sudo sed -i 's/127.0.0.1.*localhost/127.0.0.1 localhost server-3\n137.74.31.92 server-1\n149.202.167.72 server-2/g' /etc/hosts > /dev/null"
echo -e "$VERT" "Hosts configurations [OK]" "$NORMAL"



ssh -i ~/.ssh/xnet xnet@server-1 "sudo locale-gen fr_FR.UTF-8" &
ssh -i ~/.ssh/xnet xnet@server-2 "sudo locale-gen fr_FR.UTF-8" &
ssh -i ~/.ssh/xnet xnet@server-3 "sudo locale-gen fr_FR.UTF-8" & wait


################## PARALLEL DEPLOYMENT ON ALL SERVERS #################

installation_stack "1" & installation_stack "2" & installation_stack "3" & wait
