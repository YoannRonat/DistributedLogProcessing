##Elasticsearch##

Elasticsearch est un logiciel opensource qui permet de gérer une base de données documentaire distribuée. C'est à dire que Elasticsearch permet de stocker des documents dans la base ou bien d'en retrouver d'autre. Il assure également la distribution de ses données sur plusieurs machines. Elastic est basé sur des _clusters_, _nodes_, _index_ et _shards_. 

Le Cluster est l'entité englobante, c'est à dire l'ensemble des machines travaillants ensemble. Chaque machine peut contenir un ou plusieur _node_ mais l'usage de plusieurs _nodes_ sur une machine n'est recommandé que en phase de développement et surtout pas en production.

Ensuite un _index_ est une base de données qui se base sur le _cluser_ et les _nodes_ définis.

L'_index_ est divisé en _primary shards_ est une partie de la base de donnée. C'est à dire qu'un _index_ avec 2 _primary shards_ aura ses données réparties sur les 2 _primary shards_ équitablement. Ainsi si un _primary shard_ disparait alors, la moitié de la base de données disparaît. Pour éviter cela on peut utiliser des _replicas_. c'est à dire des réplication des primary qui se feront sur les autres machines. Ainsi si le _node_ contenant _primary 1_ disparait, ses données seront toujours sur un des _replicas_ sur un auter _node_. 


##Installation d'Elasticsearch##
#####source : https://www.elastic.co/guide/en/elasticsearch/reference/5.0/deb.html  
Dans un terminal en root :  

    sudo apt-get install apt-transport-https
    echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list  
    sudo apt-get update && sudo apt-get install elasticsearch  

Ensuite, pour qu'elasticSearch se lance au boot :

        sudo /bin/systemctl daemon-reload  
        sudo /bin/systemctl enable elasticsearch.service  

##Utilisation##
#####Pour démarrer et arreter Elastic :  

    sudo systemctl start elasticsearch.service  
    sudo systemctl stop elasticsearch.service  

#####Pour être sûr que elasticsearch a bien été éxécuté :  

    sudo journalctl --unit elasticsearch  


#####Vérification
Dans un navigateur sur ça machine qui éxécute elasticsearch aller à : localhost:9200/  
Ca doit afficher un JSON  


#####Configuration
La configuration se fait via le fichier elasticsearch.yml. Par défaut se fichier se trouve dans le répertoire _/etc/elasticsearch_
les éléments importants sont :
 
    cluster.name:
    
 Qui sert à définir le nom du cluster, ainsi, chaque noeud avec ce nom de cluster ne pourra rejoindre que les autres noeuds appartenants au même cluster.
 
    network.host: [_local_, _ens3_]

Permet de d'indiquer au noeud son adresse ip, les mots _local_ permet d'autoriser l'accès à elasticsearch par l'adresse localhost et _ens3_ est le nom de l'interface réseau de la machine

    discovery.zen.ping.unicast.hosts: ["server-1", "server-2", "server-3"]
    
Cette option indique au noeud en cours quelles adresses il doit ping afin de découvrir d'autres noeuds. Sachant qu'il ne se connectera qu'avec les noeuds ayant le même _cluster.name_

######Configuration des index
une fois qu'elastic est lancé, on peut créer un index, une bonne manière de créer un index est de définir directement sa configuration. Par défaut, les indexs auront 1 _primary_ et 5 _replicas_.
Attention, le nombre de _primary_ ne se configure qu'à la création de l'index, on ne peut plus revenir dessus ensuite. Cela se fait de la manière suivante :

        curl -XPUT 'localhost:9200/Index_Name?pretty' -d'
        {
            "settings" : {
                "index" : {
                    "number_of_shards" : 2, 
                    "number_of_replicas" : 2 
                }
            }
        }
        '" 




    











