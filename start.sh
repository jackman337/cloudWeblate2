#!/bin/bash

# Cannot use that due to virtual env issues
# set -eu -o pipefail

cd /app/code/

echo "=> Ensure directories"
mkdir -p /run/weblate /run/nginx

echo "=> Setup virtual env"
source /app/code/weblate-env/bin/activate

echo "=> Generating nginx.conf"
sed -e "s,##HOSTNAME##,${CLOUDRON_APP_DOMAIN}," /app/code/weblate.nginx  > /run/nginx.conf

echo "=> Ensure settings"
cat > "/run/cloudron_settings.py" <<EOF
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

AUTHENTICATION_BACKENDS = (
    'django_auth_ldap.backend.LDAPBackend',
    'weblate.accounts.auth.WeblateUserBackend',
)

import ldap
from django_auth_ldap.config import LDAPSearch, LDAPSearchUnion

# LDAP server address
AUTH_LDAP_SERVER_URI = '${CLOUDRON_LDAP_URL}'

# DN to use for authentication
# AUTH_LDAP_USER_DN_TEMPLATE = "cn=%(user)s,${CLOUDRON_LDAP_USERS_BASE_DN}"
# Depending on your LDAP server, you might use a different DN
# like:
# AUTH_LDAP_USER_DN_TEMPLATE = "${CLOUDRON_LDAP_USERS_BASE_DN}"

AUTH_LDAP_USER_SEARCH = LDAPSearchUnion(
    LDAPSearch("${CLOUDRON_LDAP_USERS_BASE_DN}", ldap.SCOPE_SUBTREE, "(username=%(user)s)"),
    LDAPSearch("${CLOUDRON_LDAP_USERS_BASE_DN}", ldap.SCOPE_SUBTREE, "(mail=%(user)s)"),
)

AUTH_LDAP_BIND_DN = "${CLOUDRON_LDAP_BIND_DN}"
AUTH_LDAP_BIND_PASSWORD = "${CLOUDRON_LDAP_BIND_PASSWORD}"

# List of attributes to import from LDAP upon login
# Weblate stores full name of the user in the full_name attribute
AUTH_LDAP_USER_ATTR_MAP = {
    # 'full_name': 'name',
    # Use the following if your LDAP server does not have full name
    # Weblate will merge them later
    'first_name': 'givenName',
    'last_name': 'sn',
    # Email is required for Weblate (used in VCS commits)
    'email': 'mail',
}
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
chown -R cloudron:cloudron /app/data

echo "=> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i weblate

