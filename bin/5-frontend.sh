#!/bin/bash
set -e
source etc/conf.sh

cd
set +e
git clone https://github.com/taigaio/taiga-front-dist.git taiga-front-dist
set -e
cd taiga-front-dist
git checkout stable

cp dist/conf.example.json dist/conf.json
cd dist/
sed -i "s| *\"api\":.*|    \"api\":\"http://$DOMAIN/api/v1/\",|" conf.json
sed -i "s| *\"eventsUrl\":.*|    \"eventsUrl\":\"ws://$DOMAIN/events\",|" conf.json
