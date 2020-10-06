#!/bin/sh

if [ -z "$(ls -A /var/www/html 2> /dev/null)" ] ; then
	echo "Direcotory empty, regenerating files..."
	cp -r /vtigercrm/* /var/www/html/
	chown -R 33:33 /var/www/html
fi

sed -i "s/_DBC_SERVER_/"${DB_HOSTNAME?err}"/"	config.db.php
sed -i "s/_DBC_PORT_/"${DB_PORT-3306}"/"		config.db.php
sed -i "s/_DBC_USER_/"${DB_USERNAME?err}"/"		config.db.php
sed -i "s/_DBC_PASS_/"${DB_PASSWORD?err}"/"		config.db.php
sed -i "s/_DBC_NAME_/"${DB_NAME?err}"/"			config.db.php

exec $@

