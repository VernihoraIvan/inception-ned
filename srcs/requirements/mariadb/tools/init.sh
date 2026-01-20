#!/bin/bash

# create socket directory
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# start mysql in background
mysqld --user=mysql --datadir='/var/lib/mysql' &

# wait for mysql
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB..."
    sleep 1
done

mysql -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat ${SECRET_PATH}mariadb_password)';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat ${SECRET_PATH}mariadb_root_password)';
FLUSH PRIVILEGES;
EOSQL

echo "Database initialized"

# stop background mysql
mysqladmin -u root -p$(cat ${SECRET_PATH}mariadb_root_password) shutdown

# Start mysql in foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql

exec "$@"
