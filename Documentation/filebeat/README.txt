Configuration de filebeat :

le script logDl.sh télécharge les logs dans /tmp/logs_tf/

Dans le dossier d'installation logstash, mettre le fichier 
filebeat_conf.conf

Remplacer le fichier /etc/filebeat/filebeat.yml par celui fourni sur le git.

Dans un premier terminal :

$ ./bin/logstash -f filebeat_conf.conf

# Logstash se lance avec la configuration filebeat_conf.conf
# et il se met en mode "écoute"
# filebeat_conf.conf spécifie que la sortie de Logstash est stdout

Dans un second terminal :

$ sudo /etc/init.d/filebeat start

ou bien :

$ sudo ./filebeat -e -c filebeat.yml -d "publish"

# filebeat va chercher les logs dans /tmp/logs_tf/ (cf filebeat.yml)
# puis les envoi à Logstash
