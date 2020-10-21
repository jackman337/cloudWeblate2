#!/bin/bash

# Cannot use that due to virtual env issues
# set -eu -o pipefail

cd /app/code/

echo "=> Ensure directories"
mkdir -p /run/weblate /run/nginx /run/celery

echo "=> Setup virtual env"
source /app/code/weblate-env/bin/activate

echo "=> Generating nginx.conf"
sed -e "s,##HOSTNAME##,${CLOUDRON_APP_DOMAIN}," /app/code/weblate.nginx  > /run/nginx.conf

echo "=> Get secret key"
if [[ ! -f /app/data/.secret_key ]]; then
    /app/code/weblate-env/lib/python3.6/site-packages/weblate/examples/generate-secret-key > /app/data/.secret_key
fi
SECRET_KEY=$(</app/data/.secret_key)

echo "=> Ensure settings"
cat > "/run/cloudron_settings.py" <<EOF
# Postgres
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

# Redis
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

# LDAP
if "${CLOUDRON_LDAP_URL}" != "":
    import ldap
    from django_auth_ldap.config import LDAPSearch, LDAPSearchUnion

    AUTHENTICATION_BACKENDS = (
        'django_auth_ldap.backend.LDAPBackend',
        'weblate.accounts.auth.WeblateUserBackend',
    )

    AUTH_LDAP_SERVER_URI = "${CLOUDRON_LDAP_URL}"
    AUTH_LDAP_BIND_DN = "${CLOUDRON_LDAP_BIND_DN}"
    AUTH_LDAP_BIND_PASSWORD = "${CLOUDRON_LDAP_BIND_PASSWORD}"
    AUTH_LDAP_USER_SEARCH = LDAPSearch("${CLOUDRON_LDAP_USERS_BASE_DN}", ldap.SCOPE_SUBTREE, "(username=%(user)s)")

    # Below would be to allow username and email login, however this results in an attempt to create two distinct users
    # AUTH_LDAP_USER_SEARCH = LDAPSearchUnion(
    #     LDAPSearch("${CLOUDRON_LDAP_USERS_BASE_DN}", ldap.SCOPE_SUBTREE, "(username=%(user)s)"),
    #     LDAPSearch("${CLOUDRON_LDAP_USERS_BASE_DN}", ldap.SCOPE_SUBTREE, "(mail=%(user)s)"),
    # )

    AUTH_LDAP_USER_ATTR_MAP = {
        'first_name': 'givenName',
        'last_name': 'sn',
        'email': 'mail',
    }

# Email settings
EMAIL_HOST = "${CLOUDRON_MAIL_SMTP_SERVER}"
EMAIL_HOST_PASSWORD = "${CLOUDRON_MAIL_SMTP_PASSWORD}"
EMAIL_HOST_USER = "${CLOUDRON_MAIL_SMTP_USERNAME}"
EMAIL_PORT = ${CLOUDRON_MAIL_SMTP_PORT}

# Other
SITE_DOMAIN = "${CLOUDRON_APP_DOMAIN}"
ALLOWED_HOSTS = [ "${CLOUDRON_APP_DOMAIN}" ]

DEFAULT_FROM_EMAIL = "${CLOUDRON_MAIL_FROM}"
SERVER_EMAIL = "${CLOUDRON_MAIL_FROM}"

SECRET_KEY = "${SECRET_KEY}"

COMPRESS_ENABLED = True
COMPRESS_OFFLINE = True

ENABLE_HTTPS = True
SESSION_COOKIE_SECURE = True
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 3600
SECURE_HSTS_PRELOAD = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True

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

echo "=> Ensure permissions"
chown -R cloudron:cloudron /app/data /run/

echo "=> Ensure and source celery config overrides"
# options for the celery workers
if [[ ! -f /app/data/.celery.env ]]; then
    echo -e 'export CELERY_MAIN_OPTIONS=""\nexport CELERY_NOTIFY_OPTIONS=""\nexport CELERY_TRANSLATE_OPTIONS=""\nexport CELERY_BACKUP_OPTIONS=""\nexport CELERY_BEAT_OPTIONS=""\n' > /app/data/.celery.env
fi
source /app/data/.celery.env

# Required celery env vars
export CELERY_WORKER_RUNNING=1
export CELERY_BROKER_URL="${CLOUDRON_REDIS_URL}"
export CELERY_RESULT_BACKEND="${CELERY_BROKER_URL}"

echo "=> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i weblate
