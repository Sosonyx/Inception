#!/bin/bash
set -e # stop le script des qu’une commande echoue

WP_DIR="/var/www/html"

if [ -f "$WP_DIR/wp-config.php" ]; then
    echo -e "\e[31mWordPress already installed.\e[0m"
    exec /usr/sbin/php-fpm8.2 -F
fi

# DL
echo -e "\e[36mDownloading WordPress...\e[0m"
curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

# Extract
echo -e "\e[36mExtracting WordPress...\e[0m"
tar -xzf /tmp/wordpress.tar.gz -C /tmp
rm -rf $WP_DIR/wp-admin $WP_DIR/wp-content $WP_DIR/wp-includes
mv /tmp/wordpress/* $WP_DIR
rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

echo -e "\e[36mCreating wp-config.php...\e[0m"

# Set le wp-config.php
cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php

sed -i "s/database_name_here/${MYSQL_DATABASE}/" $WP_DIR/wp-config.php
sed -i "s/username_here/${MYSQL_USER}/" $WP_DIR/wp-config.php
sed -i "s/password_here/${MYSQL_PASSWORD}/" $WP_DIR/wp-config.php
sed -i "s/localhost/${MYSQL_HOST}/" $WP_DIR/wp-config.php

chown www-data:www-data $WP_DIR/wp-config.php

echo -e "\e[32mSuccess! WordPress correctement installé. :)\e[0m"

exec /usr/sbin/php-fpm8.2 -F

# exec php pour remplacer le pid1 qui est le shell (pour lancer le script), par le service (php fpm ici)
# -F pour forcer le foreground (et ne pas avoir mon container qui s'arrete car il n'a plus rien a surveiller)


# l'output sort dans le stdout du container, a visualiser avec 'docker logs -f <container>'