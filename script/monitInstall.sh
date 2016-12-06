#! /bin/bash

# Install M/Monit
wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz
tar -xzvf mmonit-3.6.2-linux-x64.tar.gz
rm mmonit-3.6.2-linux-x64.tar.gz
cd mmonit-3.6.2

# Start M/Monit
./bin/mmonit start

# Install Monit
sudo apt-get install monit

# Configure Monit
sudo echo "set daemon 60

set eventqueue basedir /var/monit slot 1000
set mmonit http://admin:swordfish@149.202.167.70:8080/collector
set mmonit http://admin:swordfish@149.202.167.72:8080/collector
set mmonit http://admin:swordfish@149.202.167.76:8080/collector
set mailserver localhost
set alert root@localhost
set logfile syslog facility log_daemon

set httpd port 2812 and use address localhost
allow localhost
allow admin:monit" >> /etc/monit/monitrc

# Start Monit
sudo service monit start
