M/Monit - Getting started
========

#M/Monit

### Présentation

*M/Monit* est un outil de surveillance de services permettant de regrouper toutes les instances de *monit* (voir deuxième section) sur différentes machines dans une seule page Web.

### Installation

```
wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz
tar -xzvf mmonit-3.6.2-linux-x64.tar.gz
cd mmonit-3.6.2
```

### Utilisation

* Démarrer M/Monit : `mmonit start`
* Arrêter M/Monit : `mmonit stop`
* Vérifier que le *daemon* est activé, en se connectant à l'adresse : `http://149.202.167.70:8080/` (l'adresse IP correspond à l'adresse IP de la machine monitrice)

#Monit

### Présentation

*monit* est un outil de surveillance de services locaux. Il vérifie la disponibilité des *daemons* présents sur le serveur qui l'accueille. En cas de panne, *monit* peut alerter l'administrateur du système.

La particularité de *monit* par rapport à d'autres solutions similaires (Zabbix, Nagios) réside dans le fait qu'il est capable de déclencher des actions pour tenter de rétablir un service interrompu, comme par exemple relancer un serveur Apache s'il ne répond plus ou vider la file d'attente d'un serveur Postfix en cas d'engorgement.

### Installation

```
sudo apt-get install monit
```

### Configuration

Éditer le fichier /etc/monit/monitrc sur chaque machine afin d'obtenir les options suivantes.
Sur les machines non monitrices (celles où *M/Monit* ne tourne pas), remplacer à la ligne 3 "localhost" par l'adresse IP de la machine monitrice.

```
set daemon 60

set eventqueue basedir /var/monit slots 1000
set mmonit http://admin:swordfish@localhost:8080/collector
set mailserver localhost
set alert root@localhost
set logfile syslog facility log_daemon

set httpd port 2812 and use address localhost
allow localhost
allow admin:monit
```

L'instruction set daemon permet de définir la durée d'un "cycle" monit. Un cycle correspond à l'intervalle (en secondes) entre deux vérifications.

Cette configuration active le serveur web (https) de monit sur le port 2812. L'utilisateur est admin et son mot de passe est test. Les messages d'alertes sont envoyés à root@localhost.

Le fichier de configuration est très clair et il est relativement simple de modifier le comportement du *daemon* de surveillance.

Il faut ensuite engendrer un certificat SSL. Tout d'abord créer le répertoire qui accueillera le certificat :

```
mkdir /var/certs
cd /var/certs
```

Puis définir les options du certificat :

```
vim /var/certs/monit.cnf
```

```
# create RSA certs - Server
RANDFILE = ./openssl.rnd
[ req ]
default_bits = 1024
encrypt_key = yes
distinguished_name = req_dn
x509_extensions = cert_type
[ req_dn ]
countryName = Country Name (2 letter code)
countryName_default = MO
stateOrProvinceName    = Ile de France
stateOrProvinceName_default     = Monitoria
localityName                    = Paris
localityName_default            = Monittown
organizationName                = the_company
organizationName_default        = Monit Inc.
organizationalUnitName          = Organizational Unit Name
organizationalUnitName_default  = Dept. of Monitoring Technologies
commonName                      = Common Name (FQDN of your server)
commonName_default              = server.monit.mo
emailAddress                    = Email Address
emailAddress_default            = root@monit.mo
[ cert_type ]
nsCertType = server
```

Puis procéder à la génération du certificat :

```
openssl req -new -x509 -days 365 -nodes -config ./monit.cnf -out /var/certs/monit.pem -keyout /var/certs/monit.pem
openssl gendh 512 >> /var/certs/monit.pem
openssl x509 -subject -dates -fingerprint -noout -in /var/certs/monit.pem
chmod 700 /var/certs/monit.pem
```

Dans un environnement de développement, la sécurisation par SSL peut ne pas être nécessaire, on peut donc avantageusement remplacer la procédure ci-dessus par les lignes :

```
set httpd port 2812 and
allow admin:monit
```

### Commandes

* Démarrer monit : `/etc/init.d/monit start` ou `sudo service monit start`

### Utilisation

Pour surveiller un service donné, il suffit d'éditer le fichier monitrc et de spécifier :

* le fichier PID du service,
* les commandes de démarrage et d'arrêt du service,
* l'utilisateur système du service,
* la condition de test à effectuer,
* le(s) commande(s) à effectuer lorsque le test est positif.

Par exemple, voici comment redémarrer automatiquement le serveur SSH s'il ne répond plus :
```
check process sshd with pidfile /var/run/sshd.pid
    start program  "/etc/init.d/ssh start"
    stop program  "/etc/init.d/ssh stop"
    if failed port 22 protocol ssh then restart
    if 5 restarts within 5 cycles then timeout
```

La dernière ligne permet d'éviter des boucles infinies, notamment si la configuration du serveur SSH est erronée.