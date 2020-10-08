#!/bin/bash

# Cannot use that due to virtual env issues
# set -eu -o pipefail

cd /app/code/

echo "=> Setup virtual env"
source /app/code/weblate-env/bin/activate

echo "=> Ensure settings"
cat > "/run/cloudron_settings.py" <<EOF
DEBUG = False

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

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "${CLOUDRON_REDIS_URL}",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            "PARSER_CLASS": "redis.connection.HiredisParser",
            "PASSWORD": "${CLOUDRON_REDIS_PASSWORD}",
            "CONNECTION_POOL_KWARGS": {},
        },
        "KEY_PREFIX": "weblate",
    },
    "avatar": {
        "BACKEND": "django.core.cache.backends.filebased.FileBasedCache",
        "LOCATION": "/app/data/weblate/avatar-cache",
        "TIMEOUT": 86400,
        "OPTIONS": {"MAX_ENTRIES": 1000},
    },
}

SITE_DOMAIN = "${CLOUDRON_APP_DOMAIN}"
SECRET_KEY = "thissecretneedstochange"
COMPRESS_ENABLED = True
COMPRESS_OFFLINE = True
ALLOWED_HOSTS = [ "${CLOUDRON_APP_DOMAIN}" ]
EOF

echo "=> Ensure custom_settings"
if [[ ! -f "/app/data/custom_settings.py" ]]; then
    echo -e '# Add custom settings here to override the defaults\n' > /app/data/custom_settings.py
fi

echo "=> Run migration"
weblate migrate

if [[ ! -f /app/data/.admin_created ]]; then
    echo "=> Ensure admin"
    weblate createadmin --password "changeme123" --username "admin" --email "admin@cloudron.local"
    touch /app/data/.admin_created
fi

echo "=> Build assets"
weblate collectstatic --noinput
weblate compress

echo "=> Start webserver"
weblate runserver 0.0.0.0:8000
