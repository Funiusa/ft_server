#!/bin/bash/
sed -i 's/autoindex off/autoindex on/' /etc/nginx/sites-available/tevelyne.conf
service nginx reload
echo "autoindex on"