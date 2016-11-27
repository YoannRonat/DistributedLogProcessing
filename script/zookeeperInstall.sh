#!/bin/bash

zooDir="zookeeper"
zoorArchName="zookeeper-3.4.9.tar.gz"

wget "http://apache.crihan.fr/dist/zookeeper/current/"$zoorArchName
mkdir $zooDir
tar -zxf $zoorArchName -C $zooDir --strip-component 1
rm $zoorArchName

