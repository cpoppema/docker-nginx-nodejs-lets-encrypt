#!/bin/bash

DOMAIN=${DOMAIN:-1}

if [ "$DOMAIN" == "1" ]; then DOMAIN="pass your domain using -e" ; fi

echo "
-----------------------------------
DOMAIN
-----------------------------------
$DOMAIN
-----------------------------------
"

sed -i -e "s/\${domain}/$DOMAIN/" /etc/nginx/sites-enabled/webapp.conf
