#!/bin/bash

until mariadb -h mariadb -u$MYSQL_USER -p$(cat ${SECRET_PATH}mariadb_password) $MYSQL_DATABASE -e "SELECT 1" >/dev/null 2>&1; do
    echo "Setting up mariadb..."
    sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$(cat ${SECRET_PATH}mariadb_password) \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN \
        --admin_password=$(cat ${SECRET_PATH}wp_admin_password) \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    wp user create \
        $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$(cat ${SECRET_PATH}wp_password) \
        --allow-root

    echo "WordPress is installed."
else
    echo "WordPress is already installed."
fi

chown root:www-data /var/www/html/wp-config.php
chmod 640 /var/www/html/wp-config.php

# exec php-fpm8.2 -F
exec "$@"
