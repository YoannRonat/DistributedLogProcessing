# Kibana - Getting started
========

####Installation####
```bash
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.lis
sudo apt-get update
sudo apt-get -y install kibana
```

####Configuration####
1. Décommenter la ligne suivante : server.host: "localhost"
```
sudo sed -i 's/# server\.host.*/server.host: "localhost"/g' /opt/kibana/config/kibana.yml
```

2. Exécuter la commande suivante :
```
sudo update-rc.d kibana defaults 96 9
```

####Lancement####
```
sudo service kibana start
```

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
