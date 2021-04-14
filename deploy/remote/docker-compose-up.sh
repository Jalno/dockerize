#!/bin/sh

docker login -u $CI_DEPLOY_USER -p $CI_DEPLOY_PASSWORD $CI_REGISTRY
docker-compose -f $PRODUCTION_APP_PATH/docker-compose.yml pull
docker-compose -f $PRODUCTION_APP_PATH/docker-compose.yml up -d