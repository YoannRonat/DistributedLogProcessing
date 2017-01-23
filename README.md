#Système Distribué de Traitement des Données#

##Équipe##
* Assouline Daniel
* Baillet Valérian
* Bouvattier Jean
* Dufour Clément
* Ronat Yoann
* Russello Tom
* Sibille Gaspard
* Teughels Robin

## Présentation du projet ##
Le projet a pour but d'étudier et de mettre en application un service distribuée de traitement de log de serveurs. Nous avons choisis de travailler sur les logs d'un jeu en ligne appelé Team Fortress 2.

Notre but est de récupérer les logs sur le serveur du jeu, les traiter puis stocker et visualiser les résultats du traitement. Pour cela nous allons utiliser la stack Elastic composée de quatres logiciels:
* Filebeat pour la récupération de logs
* Logstash pour le traitement des logs
* Elasticsearch pour stocker des données
* Kibana pour la visualisation des données

De plus, nous devons utilisé trois machines pour réaliser notre traitement de logs de serveurs. Pour cela, nous allons utiliser de logiciels supplémentaires:
* Zookeeper pour la répartition des tâches entre les machines
* Monit pour la gestion des logiciels.

Notre système distribué devra alors repérer les logiciels defaillants et les relancer et, dans le pire cas, détecter une machine qui crash et essayer de la relancer. Ces pannes ne doivent en aucun cas entrainer un mauvais fonctionnements des autres machines.

## Documentations logiciels##
* [Filebeat](Documentation/Beats - Getting Started.md)
* [Logstash](Documentation/Logstash - Getting started.md)
* [ElasticSearch](Documentation/ElasticSearch - Getting Started.md)
* [Kibana](Documentation/Kibana - Getting started.md)
* [Zookeeper](Documentation/Zookeeper - Getting Started.md)
* [Monit](Documentation/Monit - Guetting started.md)

## Application de démonstration ##
### But de l'application ###
Notre application vise principalement à montrer le côté distribué de notre système. 

Pour rappel, tous les logiciels décrits précédemment sont installés sur chaque serveur de notre système et elasticsearch crée suffisamment de bases de données principales et de replicats pour que tous les serveurs de notre système possèdent les mêmes informations. C'est-à-dire que durant la démonstration, les visualisations des données,faite par kibana, doivent être les mêmes les mêmes sur les  serveurs.

### Fonctionnement de l'application ###

L'application va fonctionner de la façon suivante:
