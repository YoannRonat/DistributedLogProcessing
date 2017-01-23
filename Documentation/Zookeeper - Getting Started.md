
Zookeeper - Getting started
========

##Zookeeper standalone

###Introduction###

Zookeeper est un gestionnaire d'application distribué. Il est composé de fonction primaire permettant de synchroniser, configurer la maintenance, grouper et nommer. Il est conçu pour être utilisé simplement.

* Espace de stockage
Chaque application possède son espace de stockage partagé. Les données sont gardées en mémoire. Chaque noeud possède également son propre epace de stockage. Exemple : */app1/p_1* pour le noeud 1 de l'application app1.
* Répliqué
* Ordonné
Chaque tâche est marquée afin de représenter l'ordre des transactions de Zookeeper. 
* Rapide
Zookeeper est conçu pour être rapide sur un système qui effectue plus de lecture que d'écriture (ratio de 10:1).

### Installation et configuration ###
1. Téléchargement et extraction de l'archive, voir [à cette adresse](http://www.apache.org/dyn/closer.cgi/zookeeper/) 
2. Remplacement du fichier de configuration conf/zoo.cfg

####Paramètres de configuration####
* *tickTime* : fréquence du heartbeat
* *dataDir* : le répertoire dans lequel stocker les snaposhot de la mémoire
* *clientPort* : port d'écoute des connexions clients

### Utilisation du serveur ###
Pour démarrer
```
bin/zkServer.sh start
```

> **NB** ZooKeeper utilise log4j pour les logs.

Pour se connecter via un shell zookeeper
```
bin/zkCli.sh -server 127.0.0.1:2181
```

Commandes:

* ls
* Creation d'un noeud : `create /nodeName data`
* Vérification  des données : `get /nodeName `
* Changement des données : `set /nodeName data2`
* Suppression des données : `delete /nodeName`

##Scripts pour Zookeeper

> Pré-requis: avoir installé Zookeeper en standalone (*cf* section précédente).

Ce projet utilise [un projet sous licence apache](https://github.com/fpj/zookeeper-book-example) permettant d'illustrer l'usage de Zookeeper. L'utilisation de Zookeeper y est illustrée dans trois versions: en C et en Java avec et sans le framework [Apache Curator](http://curator.apache.org). La version Java sans Apache Curator a été utilisée.

###Fonctionnement###

####Structure####

Trois entités existent: Master, Worker et Client.
Le Master principal reçoit les jobs du Client et prends en charge son exécution. Il se charge de répartir les différents jobs sur les Worker.

####Fonctionnalités####
* Élection de leader pour le Master
Les scripts utilisés tolèrent une panne franche ou une perte de connexion de la part du Master. Dans ce cas, une élection de leader est effectuée à l'aide d'un verrou.
* Panne franche / perte de connexion du Worker
Si le Worker chargé de l'exécution d'une tâche n'est plus disponible (perte de connexion), la tâche est ré-assignée à un autre Worker
* Répartition aléatoire des jobs
Les jobs sont répartis de manière aléatoire entre les Workers

###Installation et configuration###

Les scripts sont disponibles dans le git du projet.
Pour pouvoir s'en servir, il faut les compiler à l'aide de maven à partir du répertoire de Zookeeper:
```
mvn package
```

###Démarrage des services###

####Démarrage simple####

Pour lancer le serveur Zookeeper et exécuter un Master et un Worker sur une machine, utiliser le script `zookeeper_start.sh` suivi du nom de la machine

####Démarrage pas à pas####

1. Lancement du service Zookeeper sur tous les noeuds (à partir du répertoire d'installation de Zookeeper)
	```
	sudo bin/zkServer.sh start
	```
	
2. Lancement des Masters (à partir du répertoire où se situe *ZooKeeper-Book.jar*)
	```
	java -cp ZooKeeper-Book.jar org.apache.zookeeper.book.Master server-1:2181,server-2:2181,server-3:2181
	```
	
	> **IMPORTANT** À lancer sur chaque Master

	La liste qui suit la commande est celle des Masters.

3. Lancement des Workers (à partir du répertoire où se situe *ZooKeeper-Book.jar*)
	```
	java -cp ZooKeeper-Book.jar org.apache.zookeeper.book.Worker server-1:2181,server-2:2181,server-3:2181
	```
	> **IMPORTANT** À lancer sur chaque Worker
	
	La liste qui suit la commande est celle des _Masters_.

### Utilisation du Client ###

Une fois le serveur Zookeeper lancé sur chaque nœud, ainsi que chaque Worker et Master, le client peut être utilisé (à partir du répertoire où se situe *ZooKeeper-Book.jar*) avec la commande suivante:
```
java -cp ZooKeeper-Book.jar org.apache.zookeeper.book.Client <masters> <log_start> <log_num>
```

où 

*  `<masters>` est la liste des masters suivi de leurs ports
*  `<log_start>` est le numéro log à partir duquel les logs sont téléchargés
* `<log_num>` est le nombre de logs à télécharger

**Example d'utilisation**
```
java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Client server-1:2181,server-2:2181,server-3:2181 1500000 10
```
