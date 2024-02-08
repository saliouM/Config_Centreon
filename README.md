# Config_Centreon
Etapes de configuration du serveur Centreon sous Debian 11
--------------------
Creer un utilisateur
--------------------

CREATE USER 'saliouvm'@'localhost' IDENTIFIED BY 'saliou123';
GRANT ALL PRIVILEGES ON *.* TO 'saliouvm'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;

----------------------
Le paquet centreon-database installe une configuration MariaDB optimisée pour l'utilisation avec Centreon.

Si ce paquet n'est pas installé, il faut à minima adapter la limitation LimitNOFILE à 32000 via une configuration dédiée, exemple:
--------------
$ cat /etc/systemd/system/mariadb.service.d/centreon.conf
[Service]
LimitNOFILE=32000

-------------------------------------------------
De même pour la directive MariaDB open_files_limit
-----------------------------------------------
$ cat /etc/mysql/mariadb.conf.d/80-centreon.cnf
[server]
innodb_file_per_table=1
open_files_limit=32000

----------------------------------------------------------------------
Redémarrez le service mariadb après chaque changement de configuration.
------------------------------------------------------------------------

NB: Configuration spécifique à Debian 11
MariaDB doit écouter sur toutes les interfaces au lieu d'écouter sur localhost/127.0.0.1 (valeur par défaut). Éditez le fichier suivant :

nano /etc/mysql/mariadb.conf.d/50-server.cnf

Attribuez au paramètre bind-address la valeur 0.0.0.0.

------------------------
Étape 3 : Configuration
-------------------------
Nom du serveur
Si vous le souhaitez, vous pouvez changer le nom du serveur à l'aide de la commande suivante:

hostnamectl set-hostname new-server-name

exemple:
hostnamectl set-hostname remote1

-------------------
Fuseau horaire PHP
-------------------

La timezone par défaut de PHP doit être configurée.
Exécutez la commande suivante :

echo "date.timezone = Afrique/Maroc" >> /etc/php/8.1/mods-available/centreon.ini


------------------------------------------------------------------
Après avoir sauvegardé le fichier, redémarrez le service PHP-FPM :
------------------------------------------------------------------

systemctl restart php8.1-fpm

---------------------------------------------
Gérer le lancement des services au démarrage
---------------------------------------------
Pour activer le lancement automatique des services au démarrage, exécutez la commande suivante sur le serveur Central :

systemctl enable php8.1-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd

Puis exécutez la commande suivante (sur le serveur distant si vous utilisez une base de données locale, sinon sur le serveur de base de données déporté):

systemctl enable mariadb
systemctl restart mariadb

---------------------------
Étape 4 : Installation web
----------------------------
Avant de démarrer l'installation web, démarrez le serveur Apache avec la commande suivante :

systemctl start apache2


---------------------------------------------------------------------
Terminez l'installation en réalisant les étapes de l'installation web.
---------------------------------------------------------------------

Installation web
Connectez-vous à l'interface web via http://localhost/centreon.

--------------------------------------------------------------------
Étape 1 : Welcome to Centreon setup
L'assistant de configuration de Centreon s'affiche. Cliquez sur Next
------------------------------------------------------------------------

Étape 2 : Dependency check up
Les modules et les prérequis nécessaires sont vérifiés. Ils doivent tous être satisfaits. Cliquez sur Refresh lorsque les actions correctrices nécessaires ont été effectuées.
----------------
Puis cliquez sur Next.

---------------
Étape 3 : Monitoring engine information
Definissez les chemins utilisés par le moteur de supervision. Nous recommandons d'utiliser ceux par défaut.
--------------

Puis cliquez sur Next.

-----------
Étape 4 : Broker module information
Definissez les chemins utilisés par le multiplexeur. Nous recommandons d'utiliser ceux par défaut.
----------
Puis cliquez sur Next.

----------------
Étape 5 : Admin information
Définissez les informations nécessaires pour la création de l'utilisateur par défaut, admin. Vous utiliserez ce compte pour vous connecter à Centreon la première fois. Le mot de passe doit être conforme à la politique de sécurité de mot de passe par défaut : 12 caractères minimum, lettres minuscules et majuscules, chiffres et caractères spéciaux. Vous pourrez changer cette politique par la suite.
---------


Puis cliquez sur Next.


---------------
Étape 6 : Database information
Fournissez les informations de connexion à l'instance de base de données.

Database Host Address : si vous utilisez une base de données locale, laissez ce champ vide (la valeur par défaut étant localhost). Sinon, renseignez l'adresse IP de votre base de données déportée.

Root user/password : ce compte sera utilisé pour installer les bases de données.

S'il s'agit du compte par défaut (root), le mot de passe root de la base de données est celui que vous avez défini lorsque vous avez exécuté mysql_secure_installation (que vous ayez effectué l'installation à partir des paquets ou bien des sources).
Si vous avez défini un utilisateur dédié avec des privilèges root sur toutes les bases, (par exemple pendant l'installation d'une base de donnée déportée), utilisez celui-ci. Cet utilisateur pourra être supprimé une fois l'installation web terminée.
Database user name/password: les identifiants du compte qui sera utilisé pour interagir avec les bases de données Centreon. Le compte sera créé pendant l'installation de la base.

-----------------
--------------
Puis cliquez sur Next.


------------
Quand le processus est terminé, cliquez sur Next.
-------


----------
Étape 8 : Modules installation
Sélectionnez les modules et widgets disponibles à l'installation.

Puis cliquez sur Install.
-------------

Une fois les modules installés, cliquez sur Next.


------------
Étape 9 : Installation finished
À cette étape une publicité permet de connaître les dernières nouveautés de Centreon. Si votre plate-forme est connectée à Internet vous disposez des dernières informations. Sinon l’information présente dans cette version sera proposée.
--------
L’installation est terminée, cliquez sur Finish.



------------------
Logo Centreon Docs
Version: ⭐ 23.10
Sur cette page
Installation Web
Installation web
Connectez-vous à l'interface web via http://<IP>/centreon.

Étape 1 : Welcome to Centreon setup
L'assistant de configuration de Centreon s'affiche. Cliquez sur Next.

image

Étape 2 : Dependency check up
Les modules et les prérequis nécessaires sont vérifiés. Ils doivent tous être satisfaits. Cliquez sur Refresh lorsque les actions correctrices nécessaires ont été effectuées.

image

Puis cliquez sur Next.

Étape 3 : Monitoring engine information
Definissez les chemins utilisés par le moteur de supervision. Nous recommandons d'utiliser ceux par défaut.

image

Puis cliquez sur Next.

Étape 4 : Broker module information
Definissez les chemins utilisés par le multiplexeur. Nous recommandons d'utiliser ceux par défaut.

image

Puis cliquez sur Next.

Étape 5 : Admin information
Définissez les informations nécessaires pour la création de l'utilisateur par défaut, admin. Vous utiliserez ce compte pour vous connecter à Centreon la première fois. Le mot de passe doit être conforme à la politique de sécurité de mot de passe par défaut : 12 caractères minimum, lettres minuscules et majuscules, chiffres et caractères spéciaux. Vous pourrez changer cette politique par la suite.

image

Puis cliquez sur Next.

Étape 6 : Database information
Fournissez les informations de connexion à l'instance de base de données.

Database Host Address : si vous utilisez une base de données locale, laissez ce champ vide (la valeur par défaut étant localhost). Sinon, renseignez l'adresse IP de votre base de données déportée.

Root user/password : ce compte sera utilisé pour installer les bases de données.

S'il s'agit du compte par défaut (root), le mot de passe root de la base de données est celui que vous avez défini lorsque vous avez exécuté mysql_secure_installation (que vous ayez effectué l'installation à partir des paquets ou bien des sources).
Si vous avez défini un utilisateur dédié avec des privilèges root sur toutes les bases, (par exemple pendant l'installation d'une base de donnée déportée), utilisez celui-ci. Cet utilisateur pourra être supprimé une fois l'installation web terminée.
Database user name/password: les identifiants du compte qui sera utilisé pour interagir avec les bases de données Centreon. Le compte sera créé pendant l'installation de la base.

image

Puis cliquez sur Next.

Étape 7 : Installation
L'assistant de configuration crée les fichiers de configuration et les bases de données.

image

Quand le processus est terminé, cliquez sur Next.

Étape 8 : Modules installation
Sélectionnez les modules et widgets disponibles à l'installation.

Puis cliquez sur Install.

image

Une fois les modules installés, cliquez sur Next.

image

Étape 9 : Installation finished
À cette étape une publicité permet de connaître les dernières nouveautés de Centreon. Si votre plate-forme est connectée à Internet vous disposez des dernières informations. Sinon l’information présente dans cette version sera proposée.

image

L’installation est terminée, cliquez sur Finish.

Vous pouvez maintenant vous connecter en utilisant le compte admin, et initialiser la supervision.

image

Initialisation de la supervision
Pour démarrer les processus de supervision :

Depuis l'interface web, rendez-vous dans le menu Configuration > Collecteurs.

Sélectionnez le collecteur Central dans la liste et cliquez sur Exporter la configuration.

Cochez Déplacer les fichiers générés en plus de la sélection par défaut et cliquez sur Exporter.

Connectez-vous au serveur Central.

Démarrez/redémarrez les processus de collecte :
----------




----------------------------------------------------------------------------------------------
                                                  Source
---------------------------------------------------------------------------------------------
https://www.centreon.com/fr/
