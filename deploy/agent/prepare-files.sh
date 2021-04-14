#!/bin/sh

REMOTE_DEPLOY_DIR="$(dirname $0)/../remote"
envsubst < "$REMOTE_DEPLOY_DIR/docker-compose-up.sh" > "$REMOTE_DEPLOY_DIR/docker-compose-up.prepared.sh"
chmod +x "$REMOTE_DEPLOY_DIR/docker-compose-up.prepared.sh"


envsubst < "$REMOTE_DEPLOY_DIR/ubuntu/prepare.sh" > "$REMOTE_DEPLOY_DIR/ubuntu/prepare.prepared.sh"
chmod +x "$REMOTE_DEPLOY_DIR/ubuntu/prepare.sh"
