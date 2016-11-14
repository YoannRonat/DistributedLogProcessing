# Kibana - Getting started
========

####Installation####
```bash
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.lis
sudo apt-get update
sudo apt-get -y install kibana
```

####Configuration####
1. Décommenter la ligne suivante : server.host: "localhost"
```
sudo sed -i 's/# server\.host.*/server.host: "localhost"/g' /opt/kibana/config/kibana.yml
```

2. Exécuter la commande suivante :
```
sudo update-rc.d kibana defaults 96 9
```

####Lancement####
```
sudo service kibana start
```
