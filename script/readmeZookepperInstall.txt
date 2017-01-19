Lancement du cluster Zookeeper sur les 3 machines: une fois les serveurs lancés, il y aura un leader et le reste de followers avec:
	sudo ~/zookeeper/bin/zkServer.sh start

Lancement du master sur chaque machine, élection pour désigner le master primaire et les master backup 
	java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Master server-1:2181,server-2:2181,server-3:2181

Lancement des workers sur chaque machine
	java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Worker server-1:2181,server-2:2181,server-3:2181"

Pour la soumission des tâches au master primaire, il faut utiliser la classe Client:
	java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Client server-2:2181,server-1:2181,server-3:2181 sur le manager