Pré-requis :

1. Installer unzip sur les machines esclaves (a rajouter sur le script d'installation) :

$ ssh -i ~/.ssh/xnet xnet@serveurX "sudo apt-get install unzip"

2. copier le script logDl.sh sur les machines esclaves :

$ scp logDl.sh xnet@serveurX:	# copie dans le $HOME

Déroulement :

1. repartitionLogs.sh check régulièrement les contenus des dossiers /tmp/logs_tf/ des machines esclaves.
Si le dossier est vide, c'est que la machine est inactive.
Le script envoi alors une requete à la machine esclave inactive
grace à getLogs.sh

2. geLogs.sh ordonne à une machine A de télécharger les logs
du numéro x au (x + $pas) où $pas est le nombre de logs à
télécharger par paquets.

TODO : Ce qui n'est pas encore fait :
- Savoir comment une machine esclave peut savoir si logstash 
	a bien reçu tous ses logs