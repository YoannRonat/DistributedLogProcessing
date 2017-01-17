#Logstash#
Logstash est un logiciel open source qui permet de traiter des données provenant de nombreuses sources. Il les transforme et les envoie ensuite sur le logiciel Elasticsearch. De plus, Logstash permet de traiter des nombreux types de données de manière simultanée, en utilisant ses filtres. Avec plusieurs centaines de plug-in, il est facile de personnaliser les filtres de logstash pour pouvoir traiter les données de la façon voulue.

##Installation de logstash##
(dans le répertoire d’installation)

    wget https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.tar.gz
    tar -zxvf logstash-5.0.0.tar.gz

L'éxecutable se trouve dans le dossier décompressé dans le répertoire bin. Il est aussi facile de lancer logstash en tant que service pour ne pas le lancer à chaque modification.


##Configuration##
Logstash peut être utilisé de deux manières: soit en ligne de commandes, soit en utilisant un fichier de configuration.

###Ligne de commande###
Avec l'option -e on peut exprimer la configuration de logstash directement en lignes de commande:


__Exemple de lignes de commandes__

    ```
    bin/logstash -e 'input { stdin { } } output { stdout {} }'
    ```
    
   Dans cet exemple, logstash se contente de répéter ce qu’on lui écrit.


###Fichier de conf###
Le fichier de configuration se compose de trois parties: les entrées, le traitement des entrées, la sortie des données traitées. Pour pouvoir utiliser logstash avec un fichier de configuration, il faut utiliser l'option -f.
#### Entrée de logstash ####
La première partie permet de configurer le port sur lequel logstash va recevoir les données de filebeat. Pour se connecter à filebeat, il faut alors renseigner le même port que la sortie de filebeat. De plus, si le projet est fait en utilisant plusieurs machines, cette partie permet de mettre les clés nécessaire pour que les machines puissent communiquer facilement entre elles.

__Exemple d'entrée de logstash__
```
input {
    beats {
    port => 5044
    ssl => true
    ssl_certificate => "mysslcertificate.crt"
    ssl_key => "mysslkey.key"
}
}
```

####Traitement des données####
Après avoir récupérer des logs de serveurs, logstash va devoir les parser en fonctions des patterns données par l'utilisateur. Un pattern est un ensemble de symbole que logstash va reconnaitre. Par exemple,un ensemble de caractère constitue un mot pour logstash. On peut trouver tous les patterns reconnu par défaut en suivant [ce lien](https://github.com/elastic/logstash/blob/v1.4.2/patterns/grok-patterns). Bien sur, il est possible de créer des patterns. Pour cela, il faut les écrire dans un fichier et indiquez dans logstash où trouver ce fichier.

__Exemple de patterns personnalisés__ 
```
GAMETIME %{DATE_US} - %{TIME}:

ENDGAME "Game_Over"

RED Team "Red" final score "(%{INT:Red_score})"
```
Grâce à ses patterns, logstash va alors pouvoir parser les logs pour retrouver les lignes recherchées par l'utilisateur. Pour cela, on va utiliser la fonction match de logstash pour dire quels sont les patterns recherchés. Pour avoir un résultat plus clair, il est possible d'enlever les lignes qui ne contiennent pas les patterns en utilisant la fonction drop.

__Exemple de traitement de données__
```
filter {
        grok{
        patterns_dir => ["./patterns"]
        match => {"message" => ["%{GAMETIME} %{RED}", "%{GAMETIME} %{BLUE}"]
        }
}
        if "_grokparsefailure" in [tags]{ drop{} }
}

```

####Sortie des données traitées####
Une fois que les données ont été traités, il faut envoyé le résultat du traitement au logiciel de stockage elasticsearch. Pour cela, il faut indiquez sur quelles machines il faut envoyer les données. 

De plus, il est possible d'indiquer dans quel index les données font être stockées et le type de données renvoyées pour que elasticsearch puissent les stocker efficacement.

__Exemple de sortie de données traitées__
```
output {
    elasticsearch {
        hosts => ["server-1:9200", "server-2:9200", "server-3:9200"]
        sniffing => true
        manage_template => false
        index => "filebeat-0"
        document_type => "log"
    }
}
```

 

   
