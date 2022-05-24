#!/bin/bash/

service php7.3-fpm start
service mysql start
service nginx start
echo -e "\033[32m autoindex on\033[0m"

