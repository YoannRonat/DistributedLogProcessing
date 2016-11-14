####Installation####
(dans le répertoire d’installation)

    wget https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.tar.gz
    tar -zxvf logstash-5.0.0.tar.gz

Et voilà, l'exécutable à lancer est ensuite logstash-5.0.0/bin/logstash

####Configuration####
Avec option -e pour spécifier le fichier de conf en ligne de commande exemple:

    bin/logstash -e 'input { stdin { } } output { stdout {} }'

Ici logstash se contente de répéter ce qu’on lui écrit
Avec -f pour un fichier particulier:

    bin/logstash -f fichier-de-conf.conf

####Fichier de conf####
Aller voir https://www.elastic.co/guide/en/logstash/current/configuration-file-structure.html pour trouver comment parser ce qu’on veut et ensuite rediriger comme il faut.


####Exemple####
Avec entrée standard et sortie standard

    sudo /opt/logstash/bin/logstash -e  'input { stdin { } } output { stdout {} }'

Output:

    ...
    salut les pds
    2016-11-01T11:34:17.740Z bvt salut les pds

 

   