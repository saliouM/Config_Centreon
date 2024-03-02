## Config_Centreon
## Étapes de configuration du serveur Centreon sous Debian 11
```markdown

### 1. Créer un utilisateur

```sql
CREATE USER 'saliouvm'@'localhost' IDENTIFIED BY 'saliou123';
GRANT ALL PRIVILEGES ON *.* TO 'saliouvm'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
```

### 2. Configuration du serveur MariaDB

Si le paquet `centreon-database` n'est pas installé, ajustez la configuration MariaDB.

```bash
# Exemple /etc/systemd/system/mariadb.service.d/centreon.conf
[Service]
LimitNOFILE=32000

# Exemple /etc/mysql/mariadb.conf.d/80-centreon.cnf
[server]
innodb_file_per_table=1
open_files_limit=32000
```

Redémarrez le service MariaDB après chaque changement de configuration.

Configuration spécifique à Debian 11 : MariaDB doit écouter sur toutes les interfaces.

```bash
nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Modifier bind-address à 0.0.0.0
```

### 3. Configuration du serveur

#### - Nom du serveur

```bash
hostnamectl set-hostname new-server-name
```

#### - Fuseau horaire PHP

```bash
echo "date.timezone = Afrique/Maroc" >> /etc/php/8.1/mods-available/centreon.ini
systemctl restart php8.1-fpm
```

#### - Gérer le lancement des services au démarrage

```bash
systemctl enable php8.1-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd
systemctl enable mariadb
systemctl restart mariadb
```

### 4. Installation web

Avant de démarrer l'installation web, démarrez le serveur Apache.

```bash
systemctl start apache2
```

Terminez l'installation en réalisant les étapes de l'installation web.

#### - Installation web

Connectez-vous à l'interface web via [http://localhost/centreon](http://localhost/centreon).

1. **Étape 1 : Welcome to Centreon setup**
   - Cliquez sur Next.

2. **Étape 2 : Dependency check up**
   - Cliquez sur Refresh lorsque les actions correctrices nécessaires ont été effectuées.
   - Cliquez sur Next.

3. **Étape 3 : Monitoring engine information**
   - Cliquez sur Next.

4. **Étape 4 : Broker module information**
   - Cliquez sur Next.

5. **Étape 5 : Admin information**
   - Cliquez sur Next.

6. **Étape 6 : Database information**
   - Cliquez sur Next.

7. **Étape 7 : Installation**
   - Cliquez sur Next.

8. **Étape 8 : Modules installation**
   - Cliquez sur Install.

9. **Étape 9 : Installation finished**
   - Cliquez sur Finish.

L’installation est terminée, vous pouvez maintenant vous connecter en utilisant le compte admin, et initialiser la supervision.

Pour plus d'informations, consultez [le site de Centreon](https://www.centreon.com/fr/).
