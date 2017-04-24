#!/bin/bash

log () {
  echo ""
  echo $1
  echo ""
}
logTitle () {
  echo ""
  echo "########################"
  echo "##### "$1
  echo "########################"
  echo ""
}

source /usr/bin/envTaiga.sh



logTitle "PREREQUIES"

log "Installing dependencies for Taiga Back..."

sudo apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev
sudo apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev
sudo apt-get install -y automake libtool libffi-dev curl git tmux gettext

log "Creating log directory..."

mkdir $LOG_DIR

log "Installing database..."

sudo apt-get install -y postgresql-9.5 postgresql-contrib-9.5
sudo apt-get install -y postgresql-doc-9.5 postgresql-server-dev-9.5

log "Setting up Python environment"

sudo apt-get install -y python3 python3-pip python-dev python3-dev python-pip virtualenvwrapper
sudo apt-get install -y libxml2-dev libxslt-dev
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh




logTitle "TAIGA BACK"

log "Cloning Taiga Back..."

cd $TAIGA_HOME
git clone https://github.com/taigaio/taiga-back.git taiga-back
cd taiga-back
git checkout $TAIGA_BACK_COMMIT

log "Installing Taiga Back Python dependencies..."

mkvirtualenv -p /usr/bin/python3.5 taiga
pip install -r requirements.txt




logTitle "TAIGA FRONT"

log "Cloning Taiga Front..."

cd $TAIGA_HOME
git clone https://github.com/taigaio/taiga-front-dist.git taiga-front-dist
cd taiga-front-dist
git checkout stable




logTitle "TAIGA EVENTS"


log "Installing RabbitMQ..."

sudo apt-get install -y rabbitmq-server

log "Cloning Taiga Events..."

cd $TAIGA_HOME
git clone https://github.com/taigaio/taiga-events.git taiga-events
cd taiga-events

log "Installing all the javascript dependencies needed..."

sudo apt-get install -y nodejs
npm install
sudo npm install -g coffee-script

log "Copy Taiga Events conf file..."

/tmp/taiga_events_config.json.sh




logTitle "CIRCUS"


log "Intalling Circus..."

sudo apt-get install -y circus

log "Copy Circus conf file for Taiga..."

sudo /tmp/circus_conf_taiga.ini.sh
sudo /tmp/circus_conf_taiga-events.ini.sh

log "Create log directory..."




logTitle "NGINX"


log "Installing Nginx..."

sudo apt-get install -y nginx

log "Copy Nginx conf file..."

sudo /tmp/nginx_taiga_conf.sh

log "Disable the default nginx site..."

sudo rm /etc/nginx/sites-enabled/default

log "Enable the recently created Taiga site..."

sudo ln -s /etc/nginx/sites-available/taiga /etc/nginx/sites-enabled/taiga


log "Update mlocate db"

sudo updatedb