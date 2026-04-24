#!/bin/bash
set -e

# Prevent mysql client tools from inheriting compose host settings.
unset MYSQL_HOST
unset MYSQL_TCP_PORT

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de MariaDB..."
	# We init the structure, it will launch with mysql user (created by default),
	# and the files are going to be in /var/lib/mysql (mapped with the volume)
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	# mysqld_safe can reboot himself if error (db not ready for example) 
	# & = lauch it in background
	# --skip-network to not be pinged (TCP) during the setup and only allow communicating through UNIX Socket (local)
    mysqld_safe --skip-networking &
	# we wait until the configuration is ready
    until mysqladmin --protocol=socket ping --silent; do
        sleep 1
    done

    # Create database
    mysql --protocol=socket -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

    # Create user for remote connections (wordpress)
    mysql --protocol=socket -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

    # Create user for localhost connections
    mysql --protocol=socket -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"

    # Grant privileges to remote user
    mysql --protocol=socket -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

    # Grant privileges to localhost user
    mysql --protocol=socket -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';"

    # Set root password
    mysql --protocol=socket -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

    # Flush privileges
    mysql --protocol=socket -u root -e "FLUSH PRIVILEGES;"
	# We SHUTDOWN (mysqladmin) the process
    mysqladmin --protocol=socket -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

echo "MariaDB prête"
# We launch it in daemon to set the PID1 to mysql
exec mysqld --user=mysql --console