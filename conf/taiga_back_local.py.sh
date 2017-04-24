#!/bin/bash

source /usr/bin/envTaiga.sh

# Environment variables
TAIGA_USER=${TAIGA_USER:-root}
TAIGA_HOME=${TAIGA_HOME:-/root}
LOG_DIR=${LOG_DIR:-/root/logs}
TAIGA_SECRET=${TAIGA_SECRET:-theveryultratopsecretkey}
RABBITMQ_PORT=${RABBITMQ_PORT:-5672}
RABBITMQ_TAIGA_PWD=${RABBITMQ_TAIGA_PWD:-ratuiersauinrst}
TAIGA_BACK_API_PORT=${TAIGA_BACK_API_PORT:-8000}
DEBUG=${DEBUG:-True}
TAIGA_DB_PWD=${TAIGA_DB_PWD:-bbbbbbbb}
PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-True}

# Local variables
STATIC_URL=http://$HOSTNAME:$TAIGA_PORT/static/

# Generate conf file
FILE=$TAIGA_HOME/taiga-back/settings/local.py
touch $FILE

cat > $FILE << EOL


# -*- coding: utf-8 -*-
# Copyright (C) 2014-2016 Andrey Antukh <niwi@niwi.nz>
# Copyright (C) 2014-2016 Jesús Espino <jespinog@gmail.com>
# Copyright (C) 2014-2016 David Barragán <bameda@dbarragan.com>
# Copyright (C) 2014-2016 Alejandro Alonso <alejandro.alonso@kaleidos.net>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from .common import *

#########################################
## GENERIC
#########################################

DEBUG = $DEBUG

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': '$LOG_DIR/django.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}

#ADMINS = (
#    ("Admin", "example@example.com"),
#)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'taiga',
        'USER': '$TAIGA_USER',
        'PASSWORD': '$TAIGA_DB_PWD',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

SITES = {
    "api": {
       "scheme": "http",
       "domain": "localhost:$TAIGA_BACK_API_PORT",
       "name": "api"
    },
    "front": {
       "scheme": "http",
       "domain": "$HOSTNAME",
       "name": "front"
    },
}

#SITE_ID = "api"

HOST="http://$HOSTNAME:$TAIGA_PORT"

MEDIA_ROOT = '$TAIGA_HOME/taiga-back/media'
MEDIA_URL = "http://$HOSTNAME:$TAIGA_PORT/media/"

STATIC_ROOT = '$TAIGA_HOME/taiga-back/static'
STATIC_URL = "$STATIC_URL"
ADMIN_MEDIA_PREFIX = "$STATIC_URL/admin/"

SECRET_KEY = "$TAIGA_SECRET"

#########################################
## THROTTLING
#########################################

#REST_FRAMEWORK["DEFAULT_THROTTLE_RATES"] = {
#    "anon": "20/min",
#    "user": "200/min",
#    "import-mode": "20/sec",
#    "import-dump-mode": "1/minute"
#}


#########################################
## EVENTS SETTINGS
#########################################

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://taiga:$RABBITMQ_TAIGA_PWD@localhost:$RABBITMQ_PORT/taiga"}

#########################################
## MAIL SYSTEM SETTINGS
#########################################

#DEFAULT_FROM_EMAIL = "john@doe.com"
#CHANGE_NOTIFICATIONS_MIN_INTERVAL = 300 #seconds

# EMAIL SETTINGS EXAMPLE
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_USE_TLS = False
#EMAIL_HOST = 'localhost'
#EMAIL_PORT = 25
#EMAIL_HOST_USER = 'user'
#EMAIL_HOST_PASSWORD = 'password'

# GMAIL SETTINGS EXAMPLE
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_USE_TLS = True
#EMAIL_HOST = 'smtp.gmail.com'
#EMAIL_PORT = 587
#EMAIL_HOST_USER = 'youremail@gmail.com'
#EMAIL_HOST_PASSWORD = 'yourpassword'


#########################################
## REGISTRATION
#########################################

PUBLIC_REGISTER_ENABLED = $PUBLIC_REGISTER_ENABLED

# LIMIT ALLOWED DOMAINS FOR REGISTER AND INVITE
# None or [] values in USER_EMAIL_ALLOWED_DOMAINS means allow any domain
#USER_EMAIL_ALLOWED_DOMAINS = None

# PUCLIC OR PRIVATE NUMBER OF PROJECT PER USER
#MAX_PRIVATE_PROJECTS_PER_USER = None # None == no limit
#MAX_PUBLIC_PROJECTS_PER_USER = None # None == no limit
#MAX_MEMBERSHIPS_PRIVATE_PROJECTS = None # None == no limit
#MAX_MEMBERSHIPS_PUBLIC_PROJECTS = None # None == no limit

# GITHUB SETTINGS
#GITHUB_URL = "https://github.com/"
#GITHUB_API_URL = "https://api.github.com/"
#GITHUB_API_CLIENT_ID = "yourgithubclientid"
#GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"


#########################################
## SITEMAP
#########################################

# If is True /front/sitemap.xml show a valid sitemap of taiga-front client
#FRONT_SITEMAP_ENABLED = False
#FRONT_SITEMAP_CACHE_TIMEOUT = 24*60*60  # In second


#########################################
## FEEDBACK
#########################################

# Note: See config in taiga-front too
#FEEDBACK_ENABLED = True
#FEEDBACK_EMAIL = "support@taiga.io"


#########################################
## STATS
#########################################

STATS_ENABLED = False
#FRONT_SITEMAP_CACHE_TIMEOUT = 60*60  # In second


#########################################
## CELERY
#########################################

#from .celery import *
#CELERY_ENABLED = True
#
# To use celery in memory
#CELERY_ENABLED = True
#CELERY_ALWAYS_EAGER = True


EOL