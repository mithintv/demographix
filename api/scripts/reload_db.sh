#!/bin/sh

docker exec -u postgres postgres dropdb -f demographix
docker exec -u postgres postgres createdb demographix
flask db upgrade
