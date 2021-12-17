#!/bin/bash/

apt update && apt upgrade

#NGINX
apt install nginx -y

#SSL
apt install openssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/ssl/private/tevelyne.key \
 -out /etc/ssl/certs/tevelyne.crt \
 -subj "/C=RU/ST=Moscow/L=Moscow/O=42/OU=21/CN=tevelyne"
 
 #PHP
apt install php-fpm php-mysql -y && service php7.3-fpm start
mkdir /var/www/tevelyne
mv /tmp/tevelyne.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/tevelyne.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo "<?php
phpinfo();
?>" > /var/www/tevelyne/info.php
mv ./tmp/index.html ./var/www/tevelyne/
mv ./tmp/style ./var/www/tevelyne/

#MARIADB
apt install mariadb-server -y && service mysql start
echo "CREATE DATABASE tevelyne_db;" | mysql
echo "GRANT ALL ON tevelyne_db.* TO 'tevelyne'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;" | mysql
echo "FLUSH PRIVILEGES;" | mysql

#WORDPRESS
apt install wget -y
cd /tmp && wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv /tmp/wordpress /var/www/tevelyne/

#PHP_MY_ADMIN
mkdir /var/www/tevelyne/phpmyadmin
apt install php-json php-mbstring -y
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/tevelyne/phpmyadmin/
rm /var/www/tevelyne/phpmyadmin/config.sample.inc.php
mv /tmp/config.inc.php /var/www/tevelyne/phpmyadmin/

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
rm /tmp/*.*
echo "now autoindex on"
service nginx start

