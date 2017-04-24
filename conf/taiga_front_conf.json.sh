#!/bin/bash

source /usr/bin/envTaiga.sh

# Environment variables
TAIGA_HOME=${TAIGA_HOME:-/root}
PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-True}
DEBUG=${DEBUG:-True}


# Generate conf file
FILE=$TAIGA_HOME/taiga-front-dist/dist/conf.json
touch $FILE

cat > $FILE << EOL


{
    "api": "http://$HOSTNAME:$TAIGA_PORT/api/v1/",
    "eventsUrl": "ws://$HOSTNAME:$TAIGA_PORT/events",
    "eventsMaxMissedHeartbeats": 5,
    "eventsHeartbeatIntervalTime": 60000,
    "eventsReconnectTryInterval": 10000,
    "debug": $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]'),
    "debugInfo": $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]'),
    "defaultLanguage": "en",
    "themes": ["taiga"],
    "defaultTheme": "taiga",
    "publicRegisterEnabled": $(echo "$PUBLIC_REGISTER_ENABLED" | tr '[:upper:]' '[:lower:]'),
    "feedbackEnabled": true,
    "privacyPolicyUrl": null,
    "termsOfServiceUrl": null,
    "maxUploadFileSize": null,
    "contribPlugins": [],
    "tribeHost": null,
    "gravatar": true
}


EOL