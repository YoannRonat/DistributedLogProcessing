#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"


#! /bin/bash
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"



################# Function definitions ###################

start_stack () {

	# Elasticsearch restarting
	echo -e "$VERT" "Elasticsearch restarting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart elasticsearch  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable elasticsearch  > /dev/null"
	echo -e "$VERT" "Elasticsearch restarted on server-"$1"  [OK]" "$NORMAL"

	# Kibana restarting
	echo -e "$VERT" "Kibana restarting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart kibana  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable kibana  > /dev/null"
	echo -e "$VERT" "Kibana restarted on server-"$1"  [OK]" "$NORMAL"


	# Nginx restarting
	echo -e "$VERT" "Nginx restarting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart nginx  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable nginx  > /dev/null"
	echo -e "$VERT" "Nginx restarted on server-"$1"  [OK]" "$NORMAL"

	# Logstash restarting
	echo -e "$VERT" "Logstash restarting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo /opt/logstash/bin/logstash --configtest -f /etc/logstash/conf.d/ > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart logstash  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable logstash  > /dev/null"
	echo -e "$VERT" "Logstash restarted on server-"$1"  [OK]" "$NORMAL"

	# Loading Filebeat
	echo -e "$VERT" "Filebeat restarting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart filebeat  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable filebeat  > /dev/null"
	echo -e "$VERT" "Filebeat restarted on server-"$1"  [OK]" "$NORMAL"

	ssh -i ~/.ssh/xnet xnet@server-"$1" "cd beats-dashboards-* && ./load.sh > /dev/null && cd"

	ssh -i ~/.ssh/xnet xnet@server-"$1" "curl -XPUT 'http://localhost:9200/_template/filebeat-0?pretty' -d@filebeat-index-template.json > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "curl -XPUT 'localhost:9200/filebeat-0?pretty' -d'
{
    \"settings\" : {
        \"index\" : {
            \"number_of_shards\" : 2, 
            \"number_of_replicas\" : 2 
        }
    }
}
'"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "/home/xnet/zookeeper_start.sh" &

	# Loading M/Monit
	echo -e "$VERT" "M/Monit starting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo ~/mmonit-3.6.2/bin/mmonit start > /dev/null"
	echo -e "$VERT" "M/Monit started on server-"$1"  [OK]" "$NORMAL"

	# Loading Monit
	echo -e "$VERT" "Monit starting on server-"$1" ..." "$NORMAL"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl restart monit  > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl daemon-reload > /dev/null"
	ssh -i ~/.ssh/xnet xnet@server-"$1" "sudo systemctl enable monit  > /dev/null"
	echo -e "$VERT" "Monit started on server-"$1"  [OK]" "$NORMAL"
	
}


################# STARTING STACK ON ALL SERVERS ###################
start_stack "1" & start_stack "2" & start_stack "3" & wait
