#!/bin/bash

sudo service postgresql start

sudo service rabbitmq-server start

sudo service nginx start

sudo circusd /etc/circus/conf.d/taiga.ini