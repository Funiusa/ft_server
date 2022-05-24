FROM debian:buster-slim

# Install all
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade

RUN apt-get install nginx -y && apt-get install vim -y && \
	apt-get install php-fpm php-mysql -y && \
	apt-get install php-json php-mbstring -y && \
	apt-get install wget -y && \
	apt-get install mariadb-server -y && \
	apt-get install openssl

# OPENSSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/tevelyne.key \
	-out /etc/ssl/certs/tevelyne.crt \
	-subj "/C=RU/ST=Moscow/L=Moscow/O=42/OU=21/CN=tevelyne"

COPY ./srcs/ ./tmp/

# configuring PHP
RUN mkdir /var/www/tevelyne && \
	mv /tmp/tevelyne.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/tevelyne.conf /etc/nginx/sites-enabled/ && \
	rm /etc/nginx/sites-enabled/default

# configuring MariaDB and Wordpress from shell
RUN bash /tmp/db_wp_conf.sh

# configuring  PHP_MY_ADMIN
RUN mkdir /var/www/tevelyne/phpmyadmin && \
	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
	tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/tevelyne/phpmyadmin/ && \
	rm /var/www/tevelyne/phpmyadmin/config.sample.inc.php && \
	mv /tmp/config.inc.php /var/www/tevelyne/phpmyadmin/


RUN  chown -R www-data:www-data /var/www/* && \
	chmod -R 755 /var/www/* && \
	mv /tmp/build.sh . && cd / && \
	rm /tmp/*.* && rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

EXPOSE 80/tcp 8088 443

COPY ./srcs/autoindex.sh .

CMD bash build.sh && bash

# for switch autoindex use - "bash autoindex.sh"
