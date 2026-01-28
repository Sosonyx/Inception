#!/bin/bash
set -e # stop le script des qu’une commande echoue

WP_DIR="/var/www/html"

if [ -f "$WP_DIR/wp-config.php" ]; then
    echo -e "\e[31mWordPress already installed.\e[0m"
    exec /usr/sbin/php-fpm8.2 -F
fi

echo -e "\e[36mDownloading WordPress...\e[0m"
curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

echo -e "\e[36mExtracting WordPress...\e[0m"
tar -xzf /tmp/wordpress.tar.gz -C /tmp
rm -rf $WP_DIR/wp-admin $WP_DIR/wp-content $WP_DIR/wp-includes
mv /tmp/wordpress/* $WP_DIR
rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

chown -R www-data:www-data $WP_DIR

echo -e "\e[32mSuccess! WordPress correctement installé. :)\e[0m"
exec /usr/sbin/php-fpm8.2 -F

# l'output sort dans le stdout du container, a visualiser avec 'docker logs -f <container>'