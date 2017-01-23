##Elasticsearch##

Elasticsearch est un logiciel opensource qui permet de gérer une base de données documentaire distribuée. C'est à dire que Elasticsearch permet de stocker des documents dans la base ou bien d'en retrouver d'autre. Il assure également la distribution de ses données sur plusieurs machines.
======


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
pour éviter des débordements de mémoire :  
sudo sysctl vm.swappiness=1




    











