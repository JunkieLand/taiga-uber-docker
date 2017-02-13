#!/bin/bash

source /tmp/env.sh

# Environment variables
TAIGA_USER=${TAIGA_USER:-root}
TAIGA_HOME=${TAIGA_HOME:-/root}
LOG_DIR=${LOG_DIR:-/root/logs}
TAIGA_BACK_API_PORT=${TAIGA_BACK_API_PORT:-8001}


# Generate conf file
mkdir -p /etc/circus/conf.d
FILE=/etc/circus/conf.d/taiga.ini
touch $FILE

cat >> $FILE << EOL

[circus]
statsd = false

[watcher:taiga]
working_dir = $TAIGA_HOME/taiga-back
cmd = gunicorn
args = -w 3 -t 60 --pythonpath=. -b 127.0.0.1:$TAIGA_BACK_API_PORT taiga.wsgi
uid = $TAIGA_USER
numprocesses = 1
autostart = true
send_hup = true
stdout_stream.class = FileStream
stdout_stream.filename = $LOG_DIR/gunicorn.stdout.log
stdout_stream.max_bytes = 10485760
stdout_stream.backup_count = 4
stderr_stream.class = FileStream
stderr_stream.filename = $LOG_DIR/gunicorn.stderr.log
stderr_stream.max_bytes = 10485760
stderr_stream.backup_count = 4

[env:taiga]
PATH = $TAIGA_HOME/.virtualenvs/taiga/bin:$PATH
TERM=rxvt-256color
SHELL=/bin/bash
USER=$TAIGA_USER
LANG=en_US.UTF-8
HOME=$TAIGA_HOME
PYTHONPATH=$TAIGA_HOME/.virtualenvs/taiga/lib/python3.5/site-packages

EOL