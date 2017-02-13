#!/bin/bash

# Public environment
SCHEME=${SCHEME:-http}
TAIGA_HOSTNAME=${TAIGA_HOSTNAME:-localhost}
DEBUG=${DEBUG:-True}
PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-True}


# Private environment varibles
TAIGA_USER=taiga
TAIGA_HOME=/home/taiga
LOG_DIR=$TAIGA_HOME/logs
RABBITMQ_TAIGA_PWD=ratuiersauinrst
TAIGA_SECRET=theveryultratopsecretkey
TAIGA_BACK_API_PORT=8000
TAIGA_EVENTS_PORT=8888
TAIGA_DB_PWD=bupoauiejldv
TAIGA_BACK_COMMIT=3.0.0