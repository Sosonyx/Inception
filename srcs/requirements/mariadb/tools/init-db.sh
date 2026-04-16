#!/bin/bash
set -e

# Prevent mysql client tools from inheriting compose host settings.
unset MYSQL_HOST
unset MYSQL_TCP_PORT

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --skip-networking &
    until mysqladmin --protocol=socket ping --silent; do
        sleep 1
    done

    mysql --protocol=socket -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin --protocol=socket -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

echo "MariaDB prête"
exec mysqld --user=mysql --console