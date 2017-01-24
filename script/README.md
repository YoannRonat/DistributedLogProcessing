#Les scripts

## Structure du dossier

	script/	        # Dossier contenant les scripts et leurs ressources
		ressources/ # Fichiers de configuration pour la stack

###Les scripts sont les suivants: 

#### install.sh
Permet d'installer la stack sur les 3 machines via le manager.  
Requiert que la machine manager ait tous les scripts et le dossier ressources sur son /home.  
Utilisation : `./install.sh`

#### configuration.sh
Permet de configurer les différents composants de la stack via le manager.  
Requiert que le script install.sh ait été lancé auparavant.  
Utilisation: `./configuration.sh`

#### start.sh
Permet de démarrer les composants de la stack via le manager.  
Requiert que le script configuration.sh ait été lancé auparavant.  
Utilisation : `./start.sh`

#### stop.sh
Permet de stopper les composants de la stack via le manager.  
Utilisation: `./stop.sh`

#### uninstall.sh
Permet de désinstaller les éléments de la stack (sauf java car il est long à télécharger à chaque fois) via le manager.  
Utilisation: `./uninstall.sh`

#### kill.sh
Permet de kill un processus pendant son exécution via le manager.  
Utilisation: `./kill.sh id_machine nom_processus`

#### zookeeper_start.sh
Permet de créer un serveur zookeeper, de lancer un master et un worker sur la machine où est exécuté le script.  
Utilisation: `./zookeeper_start.sh`

#### broadcast_cmd.sh
Permet d'executer une même commande sur les trois serveurs.  
Requiert que le fichier hosts soit à jour avec le nom associé à l'IP de chacune des machines  
Utilisation: `./broadcast_cmd "commande"`

#### run_benchmark.sh
Permet d'exécuter des tests de performances pour avoir une sortie en CSV dans `/tmp/results`
Requiert que la stack soit lancée.  
Utilisation `./run_benchmark.sh server-1:2181,server-2:2181,server-3:2181 [log de début] [nb de logs à DL]`

#### getLog.sh
Permet de télécharger un log sur la plateforme [Logs TeamFortress](http://logs.tf/)  
Utilisation `./getLog.sh id_log`
#### 
