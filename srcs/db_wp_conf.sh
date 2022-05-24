#!/bin/bash

echo "<?php
phpinfo();
?>" > /var/www/tevelyne/info.php && \
		mv ./tmp/index.html ./var/www/tevelyne/ && \
		mv ./tmp/style ./var/www/tevelyne/

# configuring  MariaDB
echo "CREATE DATABASE tevelyne_db;" | mysql
echo "GRANT ALL ON tevelyne_db.* TO 'tevelyne'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;" | mysql
echo "FLUSH PRIVILEGES;" | mysql

echo "\033[0;32mSUCCESS\033[0m"

# configuring WORDPRESS
cd /tmp && wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv /tmp/wordpress /var/www/tevelyne/

