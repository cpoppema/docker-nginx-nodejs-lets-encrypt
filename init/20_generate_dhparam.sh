#!/bin/bash

# Diffie-Hellman parameter for DHE ciphersuites.
if [ ! -f /etc/ssl/certs/dhparam.pem ]; then
    openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
fi
