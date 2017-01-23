Beats - Getting started
========

####Introduction####
Il existe 3 types de récupérateurs de données :

 - Filebeat (fichiers de logs)
 - MetricBeat (métriques)
 - PacketBeat (données réseau)
 - WinLogBeat (donnée événements de fenêtres)

Dans le cadre de ce projet, c'est filebeat qui va être utilisé

####Fonctionnalité####

Le fichier de configuration de Filebeat permet de passer un dossier en paramètre.
Dans notre cas, le dossier spécifié est /tmp/logs_tf/*.log
Filebeat se met alors en mode écoute et traite tous les fichiers .log qui se trouvent dans le dossier /tmp/logs_tf/ pour les envoyer à logstash.

####Installation####
 1. Utilisation d'un packet debian (bash)
```bash
    wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
    sudo dpkg -i filebeat-5.0.0-amd64.deb
```
 2. Utilisation du fichier tar.gz
Avec une barre de progression, voir [ici](http://stackoverflow.com/questions/22676/how-do-i-download-a-file-over-http-using-python)

#### Configuration####
Si l'installation a été faite en utilisant un .rpm ou un .deb, le fichier de configuration est `/etc/filebeat/filebeat.yml`

Il va falloir configurer plusieurs choses. Tout ce passe dans le fichier de configuration filebeat.yml.

	 - Emplacement des logs
		 Il faut spécifier le chemin d'accès aux logs:
			⇒ sous filebeat.prospectors :
				`path:
					- /var/log/*.log par exemple

	 - Emplacement de la sortie pour elastic :
		⇒ sous output.elasticsearch il faut définir le serveur local.


####Lancement du deamon####
`sudo /etc/init.d/filebeat start`
ou
`sudo ./filebeat -e -c filebeat.yml`

####Désinstallation####
 `sudo dpkg -r filebeat`
