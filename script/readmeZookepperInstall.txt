Les machines distantes téléchargent le zookeeper-master-worker présent sur le github :
$ svn checkout https://github.com/...

Les machines distantes le compilent grace à maven

Puis elles lancent le daemon du master-worker (master sur server-1, worker sur 2 et3)

Les parties intéressantes du projet java zookeeper-master-worker à regarder sont les suivantes :
Worker.java : fonction public void run() ligne 350
	ici est exécuté la commande de téléchargement de log
	
Client.java : fonction main (à la fin)
	Cette fonction est exécuté par la machine qui lance les scripts de déploiement.
	Le code actuel envoi des jobs pour télécharger les logs 1500000 à 1500100.
	
commande à lancer pour exécuter le client : (à ajuster bien sûr)
$ java -cp .:/home/robin/Documents/zookeeper-3.4.8/zookeeper-3.4.8.jar:/home/robin/Documents/zookeeper-3.4.8/lib/slf4j-api-1.6.1.jar:/home/robin/Documents/zookeeper-3.4.8/lib/slf4j-log4j12-1.6.1.jar:/home/robin/Documents/zookeeper-3.4.8/lib/log4j-1.2.16.jar:/home/robin/Travail/SDTD/tests/zookeeper-book-example/target/ZooKeeper-Book-0.0.1-SNAPSHOT.jar org.apache.zookeeper.book.Client server-1:2181
