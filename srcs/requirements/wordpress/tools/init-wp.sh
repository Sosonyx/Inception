#!/bin/bash
set -e

WP_DIR="/var/www/html"

# Attendre que MariaDB soit prête
echo "Attente de MariaDB..."
until mysqladmin ping -h "${MYSQL_HOST}" -u "${MYSQL_USER}" --password="${MYSQL_PASSWORD}" --silent 2>/dev/null; do
    sleep 2
done
echo "MariaDB prête."

# Si WordPress est déjà installé, on lance juste php-fpm
if [ -f "$WP_DIR/wp-config.php" ]; then
    echo "WordPress déjà installé."
    exec /usr/sbin/php-fpm8.2 -F
fi

# Téléchargement et extraction
echo "Téléchargement de WordPress..."
curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp
rm -rf $WP_DIR/wp-admin $WP_DIR/wp-content $WP_DIR/wp-includes
mv /tmp/wordpress/* $WP_DIR
rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# Création du wp-config.php
echo "Création de wp-config.php..."
wp config create \
    --path="$WP_DIR" \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${MYSQL_HOST}" \
    --allow-root

# Installation de WordPress
echo "Installation de WordPress..."
wp core install \
    --path="$WP_DIR" \
    --url="https://${DOMAIN_NAME}" \
    --title="Inception" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root

# Création d'un second utilisateur
echo "Création du second utilisateur..."
wp user create \
    --path="$WP_DIR" \
    "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=editor \
    --allow-root

chown -R www-data:www-data "$WP_DIR"

echo "WordPress installé avec succès."

exec /usr/sbin/php-fpm8.2 -F
