#!/bin/bash
set -e
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
source etc/conf.sh

cd
  # Add users to postgresql and rabbitmq, fails on second run
set +e
sudo -u postgres createuser taiga
sudo -u postgres createdb taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0
sudo rabbitmqctl add_user taiga $RABBITPASSWORD
sudo rabbitmqctl add_vhost taiga
sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"
set -e

mkdir -p ~/logs
set +e
git clone https://github.com/taigaio/taiga-back.git taiga-back
set -e
cd taiga-back
git checkout stable

echo "from .common import *

MEDIA_URL = \"http://${DOMAIN}/media/\"
STATIC_URL = \"http://${DOMAIN}/static/\"
SITES[\"front\"][\"scheme\"] = \"http\"
SITES[\"front\"][\"domain\"] = \"$DOMAIN\"

SECRET_KEY = \"$SECRETKEY\"

DEBUG = False
PUBLIC_REGISTER_ENABLED = True

DEFAULT_FROM_EMAIL = \"no-reply@example.com\"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

#CELERY_ENABLED = True

EVENTS_PUSH_BACKEND = \"taiga.events.backends.rabbitmq.EventsPushBackend\"
EVENTS_PUSH_BACKEND_OPTIONS = {\"url\": \"amqp://taiga:${EVENTSPASSWORD}@localhost:5672/taiga\"}

# Uncomment and populate with proper connection parameters
# for enable email sending. EMAIL_HOST_USER should end by @domain.tld
#EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
#EMAIL_USE_TLS = False
#EMAIL_HOST = "localhost"
#EMAIL_HOST_USER = ""
#EMAIL_HOST_PASSWORD = ""
#EMAIL_PORT = 25

# Uncomment and populate with proper connection parameters
# for enable github login/singin.
#GITHUB_API_CLIENT_ID = "yourgithubclientid"
#GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"
" > settings/local.py

  # Create new virtual environment, let it fail from running in a script
set +e
mkvirtualenv -p /usr/bin/python3.5 taiga
set -e
source ~/.virtualenvs/taiga/bin/activate
~/.virtualenvs/taiga/bin/pip install -r requirements.txt

~/.virtualenvs/taiga/bin/python manage.py migrate --noinput
~/.virtualenvs/taiga/bin/python manage.py loaddata initial_user

~/.virtualenvs/taiga/bin/python manage.py loaddata initial_project_templates
~/.virtualenvs/taiga/bin/python manage.py compilemessages
~/.virtualenvs/taiga/bin/python manage.py collectstatic --noinput
