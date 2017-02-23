#!/bin/bash

source /usr/bin/envTaiga.sh


sudo service postgresql start

sudo service rabbitmq-server start

sudo rabbitmqctl add_user taiga $RABBITMQ_TAIGA_PWD
sudo rabbitmqctl add_vhost taiga
sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"

sudo service nginx start

sudo circusd /etc/circus/conf.d/taiga.ini