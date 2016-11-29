#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definition ###################

installation_stack () {

	# These variables allow us to use ssh or not depending on the server
	cmd=""
	end_cmd=""
	num="1"
	[[ $# > 0 ]] &&  cmd="ssh -i  ~/.ssh/xnet xnet@server-$1 \"" && end_cmd="\"" && num="$1"


	# Unzip installation
	echo -e "$VERT" "Unzip installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get install unzip"$end_cmd""
	echo -e "$VERT" "Unzip installation on server-"$num" [OK]" "$NORMAL"


	# Java installation
	echo -e "$VERT" "Java installation on server-"$num"..." "$NORMAL"
	eval ""$cmd"echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections"$end_cmd""
	eval ""$cmd"sudo add-apt-repository -y ppa:webupd8team/java 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get update 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get -y install oracle-java8-installer 2>&1"$end_cmd""
	echo -e "$VERT" "Java installation on server-"$num" [OK]" "$NORMAL"

	# Elasticsearch installation
	echo -e "$VERT" "Elasticsearch installation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"echo 'deb http://packages.elastic.co/elasticsearch/2.x/debian stable main' | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list 2>&1"$end_cmd""
	eval ""$cmd"wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get update 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get -y install elasticsearch --allow-unauthenticated 2>&1"$end_cmd""
	echo -e "$VERT" "Elasticsearch installation on server-"$num"  [OK]" "$NORMAL"

	# Kibana installation
	echo -e "$VERT" "Kibana installation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"echo 'deb http://packages.elastic.co/kibana/4.4/debian stable main' | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list 2>&1 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get update 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get -y install kibana --allow-unauthenticated 2>&1"$end_cmd""
	echo -e "$VERT" "Kibana installation on server-"$num"  [OK]" "$NORMAL"


	# Nginx installation
	echo -e "$VERT" "Nginx installation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"yes | sudo apt-get install nginx apache2-utils 2>&1"$end_cmd""
	echo -e "$VERT" "Nginx installation on server-"$num"  [OK]" "$NORMAL"

	# Logstash installation
	echo -e "$VERT" "Logstash installation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get update 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get install logstash --allow-unauthenticated 2>&1"$end_cmd""
	echo -e "$VERT" "Logstash installation on server-"$num"  [OK]" "$NORMAL"

	# Filebeat installation
	echo -e "$VERT" "Filebeat Package installation on server-"$num" ..." "$NORMAL"
	eval ""$cmd"echo 'deb https://packages.elastic.co/beats/apt stable main' |  sudo tee -a /etc/apt/sources.list.d/beats.list 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get update 2>&1"$end_cmd""
	eval ""$cmd"yes | sudo apt-get install filebeat --allow-unauthenticated 2>&1"$end_cmd""
	echo -e "$VERT" "Filebeat Package installation on server-"$num"  [OK]" "$NORMAL"
}


################# TOOLS INSTALLATION ON SERVER-1 #################
sudo locale-gen fr_FR.UTF-8

# Hosts configurations
echo -e "$VERT" "Hosts configurations..." "$NORMAL"
sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost server-1\n149.202.167.72 server-2\n149.202.167.66 server-3/g' /etc/hosts 2>&1
echo -e "$VERT" "Hosts configurations [OK]" "$NORMAL"
installation_stack 


################# DEPLOYMENT ON SERVER-2 #################

ssh -i ~/.ssh/xnet xnet@server-2 "sudo locale-gen fr_FR.UTF-8"

# Hosts configurations on server-2
echo -e "$VERT" "Hosts configurations on server-2..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@server-2 "sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost server-2\n149.202.167.70 server-1\n149.202.167.66 server-3/g' /etc/hosts 2>&1"
echo -e "$VERT" "Hosts configurations on server-2 [OK]" "$NORMAL"

installation_stack "2"

################## DEPLOYMENT ON SERVER-3 #################

ssh -i ~/.ssh/xnet xnet@server-3 "sudo locale-gen fr_FR.UTF-8"

# Hosts configurations on server-3
echo -e "$VERT" "Hosts configurations on server-3..." "$NORMAL"
ssh -i ~/.ssh/xnet xnet@server-3 "sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost server-3\n149.202.167.70 server-1\n149.202.167.72 server-2/g' /etc/hosts 2>&1"
echo -e "$VERT" "Hosts configurations on server-3 [OK]" "$NORMAL"

installation_stack "3"
