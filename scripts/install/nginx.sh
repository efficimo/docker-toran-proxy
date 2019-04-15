#!/bin/bash

# Basic Auth
echo "Detecting HTTP Basic Authentication Configuration"
if [ "${TORAN_AUTH_ENABLE}" != "false" ]; then

    if [ ! -e /etc/nginx/.htpasswd ]; then

        echo "Generating .htpasswd file"

        htpasswd -bc /etc/nginx/.htpasswd ${TORAN_AUTH_USER} ${TORAN_AUTH_PASSWORD}

    else

        echo "Skipping .htpasswd generation - already exists."

    fi

    echo "Configuring Nginx for HTTP Basic Authentication..."
    sed -i "s|# auth_basic|auth_basic|g" /etc/nginx/sites-available/toran-proxy-http.conf

fi

# Vhosts
echo "Loading Nginx vhosts..."
rm -f /etc/nginx/sites-enabled/*

sed -i "s|TORAN_HTTP_PORT|$TORAN_HTTP_PORT|g" /etc/nginx/sites-available/toran-proxy-http.conf
ln -s /etc/nginx/sites-available/toran-proxy-http.conf /etc/nginx/sites-enabled/toran-proxy-http.conf

# Logs
mkdir -p $DATA_DIRECTORY/logs/nginx
