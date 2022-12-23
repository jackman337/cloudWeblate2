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

echo "=> Get secret key"
if [[ ! -f /app/data/.secret_key ]]; then
    weblate-generate-secret-key > /app/data/.secret_key
fi
export SECRET_KEY=$(</app/data/.secret_key)

echo "=> Ensure custom_settings"
if [[ ! -f "/app/data/custom_settings.py" ]]; then
    echo -e '# Add custom settings here to override the defaults\n' > /app/data/custom_settings.py
fi

echo "=> Run migration"
weblate migrate

echo "=> Ensure default groups"
weblate setupgroups

if [[ ! -f /app/data/.admin_created ]]; then
    echo "=> Ensure admin"
    weblate createadmin --password "changeme123" --username "admin" --email "admin@cloudron.local"
    touch /app/data/.admin_created
fi

echo "=> Build assets"
weblate collectstatic --noinput --clear --link
weblate compress

echo "=> Ensure permissions"
chown -R cloudron:cloudron /app/data /run/

echo "=> Ensure and source celery config overrides"
# make sure options for the celery workers exist
export CELERY_MAIN_OPTIONS=""
export CELERY_NOTIFY_OPTIONS=""
export CELERY_TRANSLATE_OPTIONS=""
export CELERY_BACKUP_OPTIONS=""
export CELERY_BEAT_OPTIONS=""
export CELERY_MEMORY_OPTIONS=""

# source custom overrides
if [[ ! -f /app/data/.celery.env ]]; then
    echo -e 'export CELERY_MAIN_OPTIONS=""\nexport CELERY_NOTIFY_OPTIONS=""\nexport CELERY_TRANSLATE_OPTIONS=""\nexport CELERY_BACKUP_OPTIONS=""\nexport CELERY_BEAT_OPTIONS=""\nexport CELERY_MEMORY_OPTIONS=""\n' > /app/data/.celery.env
fi
source /app/data/.celery.env

# Required celery env vars
export CELERY_WORKER_RUNNING=1
export CELERY_BROKER_URL="${CLOUDRON_REDIS_URL}"
export CELERY_RESULT_BACKEND="${CELERY_BROKER_URL}"

echo "=> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i weblate
