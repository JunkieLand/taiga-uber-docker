#!/bin/bash

source /usr/bin/envTaiga.sh

# Environment variables
TAIGA_HOME=${TAIGA_HOME:-/root}
LOG_DIR=${LOG_DIR:-/root/logs}
TAIGA_BACK_API_PORT=${TAIGA_BACK_API_PORT:-8001}
TAIGA_EVENTS_PORT=${TAIGA_EVENTS_PORT:-8888}


# Generate conf file
mkdir -p /etc/nginx/sites-available/
FILE=/etc/nginx/sites-available/taiga
touch $FILE

cat > $FILE << EOL

server {
    listen 80 default_server;
    server_name _;

    large_client_header_buffers 4 32k;
    client_max_body_size 50M;
    charset utf-8;

    access_log $LOG_DIR/nginx.access.log;
    error_log $LOG_DIR/nginx.error.log;

    # Frontend
    location / {
        root $TAIGA_HOME/taiga-front-dist/dist/;
        try_files \$uri \$uri/ /index.html;
    }

    # Backend
    location /api {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:$TAIGA_BACK_API_PORT/api;
        proxy_redirect off;
    }

    # Django admin access (/admin/)
    location /admin {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:$TAIGA_BACK_API_PORT\$request_uri;
        proxy_redirect off;
    }

    # Static files
    location /static {
        alias $TAIGA_HOME/taiga-back/static;
    }

    # Media files
    location /media {
        alias $TAIGA_HOME/taiga-back/media;
    }

    location /events {
       proxy_pass http://127.0.0.1:$TAIGA_EVENTS_PORT/events;
       proxy_http_version 1.1;
       proxy_set_header Upgrade \$http_upgrade;
       proxy_set_header Connection "upgrade";
       proxy_connect_timeout 7d;
       proxy_send_timeout 7d;
       proxy_read_timeout 7d;
    }
    
}

EOL