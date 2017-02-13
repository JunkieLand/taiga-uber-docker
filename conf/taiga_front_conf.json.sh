#!/bin/bash

source /tmp/env.sh

# Environment variables
TAIGA_HOME=${TAIGA_HOME:-/root}
TAIGA_BACK_API_PORT=${TAIGA_BACK_API_PORT:-8001}


# Generate conf file
FILE=$TAIGA_HOME/taiga-front-dist/dist/conf.json
touch $FILE

cat > $FILE << EOL


{
    "api": "http://localhost:$TAIGA_BACK_API_PORT/api/v1/",
    "eventsUrl": null,
    "eventsMaxMissedHeartbeats": 5,
    "eventsHeartbeatIntervalTime": 60000,
    "eventsReconnectTryInterval": 10000,
    "debug": true,
    "debugInfo": false,
    "defaultLanguage": "en",
    "themes": ["taiga"],
    "defaultTheme": "taiga",
    "publicRegisterEnabled": true,
    "feedbackEnabled": true,
    "privacyPolicyUrl": null,
    "termsOfServiceUrl": null,
    "maxUploadFileSize": null,
    "contribPlugins": [],
    "tribeHost": null,
    "gravatar": true
}


EOL