#!/bin/bash

# set -eu -o pipefail

cd /app/code/

echo "=> Setup virtual env"
source /app/code/weblate-env/bin/activate

echo "=> Ensure settings"
cat > "/run/cloudron_settings.py" <<EOF
DEBUG = True

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "${CLOUDRON_POSTGRESQL_DATABASE}",
        "USER": "${CLOUDRON_POSTGRESQL_USERNAME}",
        "PASSWORD": "${CLOUDRON_POSTGRESQL_PASSWORD}",
        "HOST": "${CLOUDRON_POSTGRESQL_HOST}",
        "PORT": "${CLOUDRON_POSTGRESQL_PORT}",
        "OPTIONS": {},
    }
}

SITE_DOMAIN = "${CLOUDRON_APP_DOMAIN}"
EOF

echo "=> Ensure custom_settings"
if [[ ! -f "/app/data/custom_settings.py" ]]; then
    echo -e '# Add custom settings here to override the defaults\n' > /app/data/custom_settings.py
fi

echo "=> Run migration"
weblate migrate

echo "=> Ensure admin"
weblate createadmin

echo "=> Build assets"
weblate collectstatic
weblate compress

echo "=> Start webserver"
weblate runserver

read
