FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

RUN mkdir -p /app/code
WORKDIR /app/code

RUN apt-get update && \
    apt-get install -y \
    libz-dev libcairo-dev gir1.2-pango-1.0 libgirepository1.0-dev libacl1-dev \
    tesseract-ocr-all libtesseract-dev libleptonica-dev \
    uwsgi-plugin-python3 python3-gdbm python3-virtualenv \
    mercurial git-svn && \
    rm -rf /var/cache/apt /var/lib/apt/lists /etc/ssh_host_*

ARG VERSION=4.4.2

RUN virtualenv --python=python3 /app/code/weblate-env && \
    . /app/code/weblate-env/bin/activate && \
    pip install Weblate==${VERSION} "django-auth-ldap>=1.3.0" git-review psycopg2-binary ruamel.yaml aeidon boto3 zeep chardet tesserocr iniparse hglib phply

RUN mv /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings_example.py /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py && \
    sed -e 's,^BASE_DIR = .*$,BASE_DIR = "/app/data/weblate/",' \
        -e 's,^REGISTRATION_OPEN = .*$,REGISTRATION_OPEN = False,' \
        -e 's,^DEBUG = .*$,DEBUG = False,' \
        -e 's,^DEFAULT_LOGLEVEL = .*$,DEFAULT_LOGLEVEL = "INFO",' \
        -i /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

# Get hub tool
RUN curl -L https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz | tar zxvf - --strip-components=2 -C /usr/bin hub-linux-amd64-2.14.2/bin/hub

# Get lab tool
RUN curl -L https://github.com/zaquestion/lab/releases/download/v0.17.2/lab_0.17.2_linux_amd64.tar.gz | tar zxvf - -C /usr/bin lab

# Configure nginx logs
RUN rm -rf /var/log/nginx && ln -s /run/nginx /var/log/nginx

# Add supervisor configs
ADD supervisor/* /etc/supervisor/conf.d/
RUN ln -sf /run/weblate/supervisord.log /var/log/supervisor/supervisord.log

# Add uwsgi config
ADD weblate.ini /etc/uwsgi/apps-enabled/weblate.ini

# Prepare custom hooks
RUN echo -e "import site\nsite.addsitedir('/run/')\nsite.addsitedir('/app/data/')\n" >> /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

# Add cloudron_settings.py hook. That file is symlinked from /run/cloudron_settings.py to for example override database
RUN echo -e 'try:\n\tfrom cloudron_settings import *\nexcept ImportError:\n\traise Exception("A cloudron_settings.py file is required to run this project")\n\n' >> /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

RUN echo -e 'LANG="C.UTF-8"' > /etc/default/locale
ENV LC_ALL='C.UTF-8'

ADD weblate.nginx start.sh /app/code/

CMD [ "/app/code/start.sh" ]
