FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

RUN mkdir -p /app/code /app/pkg
WORKDIR /app/code

RUN apt-get update && \
    apt-get install -y \
    libxml2-dev libxslt-dev libfreetype6-dev libjpeg-dev libz-dev libyaml-dev \
    libcairo-dev gir1.2-pango-1.0 libgirepository1.0-dev libacl1-dev libssl-dev \
    build-essential python3-gdbm python3-dev python3-pip python3-virtualenv virtualenv git \
    tesseract-ocr libtesseract-dev libleptonica-dev && \
    rm -rf /var/cache/apt /var/lib/apt/lists /etc/ssh_host_*

RUN virtualenv --python=python3 /app/code/weblate-env && \
    . /app/code/weblate-env/bin/activate && \
    pip install Weblate && \
    pip install psycopg2-binary && \
    pip install ruamel.yaml aeidon boto3 zeep chardet tesserocr

RUN mv /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings_example.py /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py && \
    sed -e 's,^BASE_DIR = .*$,BASE_DIR = "/app/data/weblate/",' -i /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

# Prepare custom hooks
RUN echo -e "import site\nsite.addsitedir('/run/')\nsite.addsitedir('/app/data/')\n" >> /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

# Add custom_settings.py hook. That file is symlinked from /app/data/custom_settings.py to for example override user settings
RUN echo -e 'try:\n\tfrom custom_settings import *\nexcept ImportError:\n\traise Exception("A custom_settings.py file is required to run this project")\n\n' >> /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

# Add cloudron_settings.py hook. That file is symlinked from /run/cloudron_settings.py to for example override database
RUN echo -e 'try:\n\tfrom cloudron_settings import *\nexcept ImportError:\n\traise Exception("A cloudron_settings.py file is required to run this project")\n\n' >> /app/code/weblate-env/lib/python3.6/site-packages/weblate/settings.py

ADD start.sh /app/pkg/

CMD [ "/app/pkg/start.sh" ]
