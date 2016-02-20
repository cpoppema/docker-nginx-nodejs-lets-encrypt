#!/bin/bash

PUID=${PUID:-911}
PGID=${PGID:-911}

if [ ! "$(id -u app)" -eq "$PUID" ]; then usermod -o -u "$PUID" app ; fi
if [ ! "$(id -g app)" -eq "$PGID" ]; then groupmod -o -g "$PGID" app ; fi

echo "
-----------------------------------
GID/UID
-----------------------------------
User uid:    $(id -u app)
User gid:    $(id -g app)
-----------------------------------
"

chown app:app -R /home/app/webapp
