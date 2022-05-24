#!/bin/bash

if grep -n -w -q "autoindex on" etc/nginx/sites-available/tevelyne.conf
then
	sed -i -e 's/autoindex on/autoindex off/g' etc/nginx/sites-available/tevelyne.conf;
	echo -e "\033[32m Autoindex off\033[0m";

elif grep -n -w -q "autoindex off" etc/nginx/sites-available/tevelyne.conf
then
	sed -i -e 's/autoindex off/autoindex on/g' etc/nginx/sites-available/tevelyne.conf;
	echo -e "\033[32m Autoindex on\033[0m";
fi

service nginx reload
