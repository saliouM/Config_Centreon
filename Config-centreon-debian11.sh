#!/bin/bash

# Création d'un utilisateur dans MariaDB
mysql -u root -p <<EOF
CREATE USER 'saliouvm'@'localhost' IDENTIFIED BY 'saliou123';
GRANT ALL PRIVILEGES ON *.* TO 'saliouvm'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
EOF

# Configuration du serveur MariaDB
cat <<EOL > /etc/systemd/system/mariadb.service.d/centreon.conf
[Service]
LimitNOFILE=32000
EOL

cat <<EOL > /etc/mysql/mariadb.conf.d/80-centreon.cnf
[server]
innodb_file_per_table=1
open_files_limit=32000
EOL


# Redémarrage du service MariaDB
systemctl restart mariadb

# Configuration spécifique à Debian 11
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Configuration du serveur
hostnamectl set-hostname new-server-name

# Configuration du fuseau horaire PHP
echo "date.timezone = Afrique/Maroc" >> /etc/php/8.1/mods-available/centreon.ini
systemctl restart php8.1-fpm

# Gestion du lancement des services au démarrage
systemctl enable php8.1-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd
systemctl enable mariadb
systemctl restart mariadb

# Installation web
systemctl start apache2

# Informations pour l'installation web
echo "L'installation web peut être réalisée en accédant à http://localhost/centreon"
echo "Suivez les étapes de l'assistant Centreon setup pour terminer l'installation."
