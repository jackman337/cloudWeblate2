# This file is sourced from /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings.py
import os

# run user's /app/data/custom_settings.py
try:
    from custom_settings import *
except ImportError:
    raise Exception("A custom_settings.py file is required to run this project")

# Postgres
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ["CLOUDRON_POSTGRESQL_DATABASE"],
        "USER": os.environ["CLOUDRON_POSTGRESQL_USERNAME"],
        "PASSWORD": os.environ["CLOUDRON_POSTGRESQL_PASSWORD"],
        "HOST": os.environ["CLOUDRON_POSTGRESQL_HOST"],
        "PORT": os.environ["CLOUDRON_POSTGRESQL_PORT"],
        "OPTIONS": {},
    }
}

# Redis
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": os.environ["CLOUDRON_REDIS_URL"],
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            "PARSER_CLASS": "redis.connection.HiredisParser",
            "PASSWORD": os.environ["CLOUDRON_REDIS_PASSWORD"],
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
if os.environ["CLOUDRON_LDAP_URL"] != "":
    import ldap
    from django_auth_ldap.config import LDAPSearch, LDAPSearchUnion

    AUTHENTICATION_BACKENDS = (
        'django_auth_ldap.backend.LDAPBackend',
        'social_core.backends.email.EmailAuth',
        'weblate.accounts.auth.WeblateUserBackend',
    )

    AUTH_LDAP_SERVER_URI = os.environ["CLOUDRON_LDAP_URL"]
    AUTH_LDAP_BIND_DN = os.environ["CLOUDRON_LDAP_BIND_DN"]
    AUTH_LDAP_BIND_PASSWORD = os.environ["CLOUDRON_LDAP_BIND_PASSWORD"]
    AUTH_LDAP_USER_SEARCH = LDAPSearch(os.environ["CLOUDRON_LDAP_USERS_BASE_DN"], ldap.SCOPE_SUBTREE, "(username=%(user)s)")

    # Below would be to allow username and email login, however this results in an attempt to create two distinct users
    # AUTH_LDAP_USER_SEARCH = LDAPSearchUnion(
    #     LDAPSearch(os.environ["CLOUDRON_LDAP_USERS_BASE_DN"], ldap.SCOPE_SUBTREE, "(username=%(user)s)"),
    #     LDAPSearch(os.environ["CLOUDRON_LDAP_USERS_BASE_DN"], ldap.SCOPE_SUBTREE, "(mail=%(user)s)"),
    # )

    AUTH_LDAP_USER_ATTR_MAP = {
        'first_name': 'givenName',
        'last_name': 'sn',
        'email': 'mail',
    }

# Email settings
EMAIL_HOST = os.environ["CLOUDRON_MAIL_SMTP_SERVER"]
EMAIL_HOST_PASSWORD = os.environ["CLOUDRON_MAIL_SMTP_PASSWORD"]
EMAIL_HOST_USER = os.environ["CLOUDRON_MAIL_SMTP_USERNAME"]
EMAIL_PORT = int(os.environ["CLOUDRON_MAIL_SMTP_PORT"])

# Other
SITE_DOMAIN = os.environ["CLOUDRON_APP_DOMAIN"]
ALLOWED_HOSTS = [ os.environ["CLOUDRON_APP_DOMAIN"] ]

DEFAULT_FROM_EMAIL = os.environ["CLOUDRON_MAIL_FROM"]
SERVER_EMAIL = os.environ["CLOUDRON_MAIL_FROM"]

SECRET_KEY = os.environ["SECRET_KEY"]

COMPRESS_ENABLED = True
COMPRESS_OFFLINE = True

ENABLE_HTTPS = True
SESSION_COOKIE_SECURE = True
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 3600
SECURE_HSTS_PRELOAD = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True

DEFAULT_LOGLEVEL = "INFO" # <- overwritten in main file in Dockerfile so it may be overwritten by the user
DEFAULT_LOG = "console"
LOGGING = {
    "version": 1,
    "disable_existing_loggers": True,
    "filters": {"require_debug_false": {"()": "django.utils.log.RequireDebugFalse"}},
    "formatters": {
        "syslog": {"format": "weblate[%(process)d]: %(levelname)s %(message)s"},
        "simple": {"format": "[%(asctime)s: %(levelname)s/%(process)s] %(message)s"},
        "logfile": {"format": "%(asctime)s %(levelname)s %(message)s"},
        "django.server": {
            "()": "django.utils.log.ServerFormatter",
            "format": "[%(server_time)s] %(message)s",
        },
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "simple",
        },
        "django.server": {
            "level": "INFO",
            "class": "logging.StreamHandler",
            "formatter": "django.server",
        }
    },
    "loggers": {
        "django.request": {
            "handlers": [DEFAULT_LOG],
            "level": "ERROR",
            "propagate": True,
        },
        "django.server": {
            "handlers": ["django.server"],
            "level": "INFO",
            "propagate": False,
        },
        "weblate": {"handlers": [DEFAULT_LOG], "level": DEFAULT_LOGLEVEL},
        # Logging VCS operations
        "weblate.vcs": {"handlers": [DEFAULT_LOG], "level": DEFAULT_LOGLEVEL},
        # Python Social Auth
        "social": {"handlers": [DEFAULT_LOG], "level": DEFAULT_LOGLEVEL},
        # Django Authentication Using LDAP
        "django_auth_ldap": {"handlers": [DEFAULT_LOG], "level": DEFAULT_LOGLEVEL},
        # SAML IdP
        "djangosaml2idp": {"handlers": [DEFAULT_LOG], "level": DEFAULT_LOGLEVEL},
    },
}


