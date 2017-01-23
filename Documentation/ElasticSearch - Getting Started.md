##Elasticsearch##

Elasticsearch est un logiciel opensource qui permet de gérer une base de données documentaire distribuée. C'est à dire que Elasticsearch permet de stocker des documents dans la base ou bien d'en retrouver d'autre. Il assure également la distribution de ses données sur plusieurs machines.


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




    











