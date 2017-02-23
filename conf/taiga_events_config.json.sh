#!/bin/bash

source /usr/bin/envTaiga.sh

# Environment variables
TAIGA_HOME=${TAIGA_HOME:-/root}
RABBITMQ_PORT=${RABBITMQ_PORT:-5672}
RABBITMQ_TAIGA_PWD=${RABBITMQ_TAIGA_PWD:-ratuiersauinrst}
TAIGA_SECRET=${TAIGA_SECRET:-theveryultratopsecretkey}
TAIGA_EVENTS_PORT=${TAIGA_EVENTS_PORT:-8888}


# Generate conf file
FILE=$TAIGA_HOME/taiga-events/config.json
touch $FILE

cat > $FILE << EOL

{
    "url": "amqp://taiga:$RABBITMQ_TAIGA_PWD@localhost:$RABBITMQ_PORT/taiga",
    "secret": "$TAIGA_SECRET",
    "webSocketServer": {
        "port": $TAIGA_EVENTS_PORT
    }
}


EOL