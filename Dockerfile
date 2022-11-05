FROM cloudron/base:3.2.0@sha256:ba1d566164a67c266782545ea9809dc611c4152e27686fd14060332dd88263ea

RUN mkdir -p /app/code
WORKDIR /app/code

RUN apt-get update && \
    apt-get install -y \
    libssl-dev libz-dev libcairo-dev gir1.2-pango-1.0 libgirepository1.0-dev libacl1-dev \
    tesseract-ocr-all libtesseract-dev libleptonica-dev \
    uwsgi-plugin-python3 python3-gdbm python3-virtualenv \
    libxmlsec1-dev mercurial git-svn libldap2-dev libldap-common libsasl2-dev && \
    rm -rf /var/cache/apt /var/lib/apt/lists /etc/ssh_host_*

ARG VERSION=4.14.2

RUN virtualenv --python=python3 /app/code/weblate-env && \
    . /app/code/weblate-env/bin/activate && \
    # pkgconfig required for borgbackup as dependency of weblate since 4.11
    pip install pkgconfig && \
    pip install --no-binary cffi Weblate[all]==${VERSION}

RUN mv /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings_example.py /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings.py && \
    sed -e 's,^DATA_DIR = .*$,DATA_DIR = "/app/data/weblate/data",' \
        -e 's,^REGISTRATION_OPEN = .*$,REGISTRATION_OPEN = False,' \
        -e 's,^DEBUG = .*$,DEBUG = False,' \
        -e 's,^DEFAULT_LOGLEVEL = .*$,DEFAULT_LOGLEVEL = "INFO",' \
        -i /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings.py

# Get hub tool
RUN curl -L https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz | tar zxvf - --strip-components=2 -C /usr/bin hub-linux-amd64-2.14.2/bin/hub

# Get lab tool
RUN curl -L https://github.com/zaquestion/lab/releases/download/v0.17.2/lab_0.17.2_linux_amd64.tar.gz | tar zxvf - -C /usr/bin lab

# Configure nginx logs
RUN rm -rf /var/log/nginx && ln -s /run/nginx /var/log/nginx

# Add supervisor configs
COPY supervisor/* /etc/supervisor/conf.d/
RUN ln -sf /run/weblate/supervisord.log /var/log/supervisor/supervisord.log

# Add uwsgi config
COPY weblate.ini /etc/uwsgi/apps-enabled/weblate.ini

# Prepare custom hooks
RUN echo -e "import site\nsite.addsitedir('/app/code/')\nsite.addsitedir('/app/data/')\n" >> /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings.py

# This will run /app/code/cloudron_settings.py
RUN echo -e 'try:\n\tfrom cloudron_settings import *\nexcept ImportError:\n\traise Exception("A cloudron_settings.py file is required to run this project")\n\n' >> /app/code/weblate-env/lib/python3.8/site-packages/weblate/settings.py

RUN echo -e 'LANG="C.UTF-8"' > /etc/default/locale
ENV LC_ALL='C.UTF-8'

COPY cloudron_settings.py weblate.nginx start.sh /app/code/

CMD [ "/app/code/start.sh" ]
