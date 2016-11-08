# Kibana - Getting started
========

####Installation####
```bash
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz
tar -xzf kibana-5.0.0-linux-x86_64.tar.gz
```

####Configuration####
1. Ouvrir le fichier de configuration se trouvant à l'emplacement suivant :
```
$KIBANA_HOME/config/kibana.yml
```

2. Décommenter la ligne suivante : server.host: "localhost"

####Lancement####
```
$KIBANA_HOME/bin/kibana
```
