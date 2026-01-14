#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ -d "/var/lib/mysql/${DB_NAME}" ]; then 
	echo "Database already exists"
else
	echo "Starting MariaDB service..."
	
	# Start in background directly to avoid service wrapper issues
	mariadbd-safe --skip-networking &
	pid=$!
	
	# Wait for it to be ready
	while ! mariadb-admin ping --silent; do
		sleep 1
	done

	echo "Creating Database: ${DB_NAME}"
	mariadb -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

	echo "Creating User: ${DB_USERNAME}"
	mariadb -e "CREATE USER IF NOT EXISTS \`${DB_USERNAME}\`@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
	mariadb -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USERNAME}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"

	echo "Setting Root Password..."
	mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
	mariadb -e "FLUSH PRIVILEGES;"

	echo "Stopping temporary MariaDB..."
	mariadb-admin -u root -p${DB_ROOT_PASSWORD} shutdown
	
	wait $pid
fi


exec mysqld_safe
