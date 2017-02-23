#!/bin/bash

source /usr/bin/envTaiga.sh

# Environment variables
TAIGA_USER=${TAIGA_USER:-root}
TAIGA_HOME=${TAIGA_HOME:-/root}
LOG_DIR=${LOG_DIR:-/root/logs}


# Generate conf file
mkdir -p /etc/circus/conf.d
FILE=/etc/circus/conf.d/taiga.ini
touch $FILE

cat >> $FILE << EOL


[watcher:taiga-events]
working_dir = $TAIGA_HOME/taiga-events
cmd = /usr/local/bin/coffee
args = index.coffee
uid = $TAIGA_USER
numprocesses = 1
autostart = true
send_hup = true
stdout_stream.class = FileStream
stdout_stream.filename = $LOG_DIR/taigaevents.stdout.log
stdout_stream.max_bytes = 10485760
stdout_stream.backup_count = 12
stderr_stream.class = FileStream
stderr_stream.filename = $LOG_DIR/taigaevents.stderr.log
stderr_stream.max_bytes = 10485760
stderr_stream.backup_count = 12


EOL