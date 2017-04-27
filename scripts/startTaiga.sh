#!/bin/bash

log () {
  echo ""
  echo $1
  echo ""
}

source /usr/bin/envTaiga.sh


log "Initializing database..."

sudo chown postgres /var/lib/postgresql/9.5/main/
sudo -u postgres /usr/lib/postgresql/9.5/bin/initdb -D /var/lib/postgresql/9.5/main/

sudo service postgresql start

sudo -u postgres psql -c "CREATE USER $TAIGA_USER WITH PASSWORD '$TAIGA_DB_PWD';"
sudo -u postgres createdb taiga -O $TAIGA_USER

log "Populate the database with initial basic data..."

cd $TAIGA_HOME/taiga-back
git checkout $TAIGA_BACK_COMMIT

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
mkvirtualenv -p /usr/bin/python3.5 taiga

echo "==========> python manage.py migrate --noinput"
python manage.py migrate --noinput
echo "==========> python manage.py loaddata initial_user"
python manage.py loaddata initial_user
echo "==========> python manage.py loaddata initial_project_templates"
python manage.py loaddata initial_project_templates
echo "==========> python manage.py loaddata initial_role"
python manage.py loaddata initial_role
echo "==========> python manage.py compilemessages"
python manage.py compilemessages
echo "==========> python manage.py collectstatic --noinput"
python manage.py collectstatic --noinput

log "Copy Taiga Back conf file local.py..."

/tmp/taiga_back_local.py.sh

log "Copy Taiga Front conf file..."

/tmp/taiga_front_conf.json.sh

log "Starting RabbitMQ..."

sudo service rabbitmq-server start

sudo rabbitmqctl add_user taiga $RABBITMQ_TAIGA_PWD
sudo rabbitmqctl add_vhost taiga
sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"

log "Starting Nginx..."

sudo service nginx start

log "Starting Taiga..."

sudo circusd /etc/circus/conf.d/taiga.ini