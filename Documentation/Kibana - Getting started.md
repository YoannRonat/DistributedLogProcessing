# Kibana - Getting started

###Introduction###
Kibana est un outil Open Source permettant la visualisation et l'analyse de données stockées sur [ElasticSearch](ElasticSearch - Getting Started.md). Plus généralement, il permet d'avoir un dashboard sur un serveur web (grâce à un reverse proxy du type Nginx) pour faciliter les interactions avec la base de données et permet la création de diagrammes de visualisation de l'information ainsi que des cartes.


###Installation###
```bash
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.lis
sudo apt-get update
sudo apt-get -y install kibana
```

###Configuration###
Décommenter la ligne suivante : 
```
#server.host: "localhost"
```
pour que la ligne devienne
```
server.host: "localhost"
```

###Lancement###
```
sudo service kibana start
```

###Utilisation###
Une fois Kibana correctement configuré et lancé avec un reverse proxy (nginx par exemple), vous pouvez vous rendre sur l'adresse mise dans la configuration de nginx. Dans notre cas pour le serveur 1, cette adresse est :

[http://137.74.31.92/app/kibana](http://137.74.31.92/app/kibana)


Il faut ensuite configuré l'index par défaut qui est dans notre cas `filebeat-0`  sur ElasticSearch en allant dans `Settings`, ajouter un index et taper le nom de cet index pour le créer puis appuyer sur l'étoile pour le configurer par défaut. 

À ce stade, nous pouvons voir apparaître dans `Discover` les logs qui sont en train d'être traités ou qui ont déjà été traités par la stack ELK en mettant la bonne échelle de temps.

Dans `Visualize`, vous avez plusieurs possibilités pour vos diagrammes comme `Area Chart`, `Data Table`,  `Pie Chart`, `Tile Map` etc. Choisissez celle qui correspond à la visualisation que vous désirez !

###Fonctionnement###
Kibana permet de simplement via le dashboard de faire des requêtes NoSQL à Elastic Search grâce à des templates pour récupérer les données : l'utilisateur rentre les champs sur lesquels il veut faire une somme ou appliquer des filtres par exemple et Kibana se charge de faire la requête équivalente pour les afficher sur le diagramme choisi.

###Visualisation
L'objectif est de visualiser le score total de l'équipe bleue contre celui de l'équipe rouge.

Pour cela, il faut d'abord créer une variable qui contient la somme de *Blue_score* et de *Red_score*. Nommons-la *Sum\_red\_blue* :
Cliquer sur **Settings** puis tout à gauche sur **filebeat-0**. Dans l'onglet *Scripted fields*, cliquer sur **Add Scripted Field**.
Dans le champs **Format** choisir *number* puis dans le champs **Script** remplir *doc['Red_score'].value + doc['Blue_score'].value* puis enregistrer le résultat.

On peut désormais passer à la création du Pie Chart.
Pour cela, aller dans **Visualize**->**Pie Chart**->**From a new search**.

Dans la page chargée, remplir les champs de *Slice Size* ainsi :
* **Aggregation** : sum
* **Field** : Sum\_red\_blue

Dans la partie **Buckets**, cliquer sur **Split Slices** et remplir ainsi :
* **Aggregation** : filter
* **Filter 1** : Red_score*
* **Filter 2** : Blue_score* (après avoir cliquer sur **Add Filter**)

Pour visualiser le résultat, cliquer sur *Play*
