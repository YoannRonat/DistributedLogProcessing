#! /bin/bash

sudo /home/xnet/zookeeper/bin/zkServer.sh start & sleep 5
java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Master server-1:2181,server-2:2181,server-3:2181 & sleep 5
java -cp /home/xnet/resources/ZooKeeper-Book.jar org.apache.zookeeper.book.Worker server-1:2181,server-2:2181,server-3:2181
