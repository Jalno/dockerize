#!/bin/sh

apk add openssh-client gettext
eval $(ssh-agent -s)
echo "$SSH_PRODUCTION_PRIVATE_KEY" | tr -d '\r' | ssh-add -
mkdir -p ~/.ssh
chmod 700 ~/.ssh
if [[ -f /.dockerenv ]]; then 
	echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
fi
REMOTE_DEPLOY_DIR="$(dirname $0)/../../remote"
envsubst < "$REMOTE_DEPLOY_DIR/docker-compose-up.sh" > "$REMOTE_DEPLOY_DIR/docker-compose-up.prepared.sh"
chmod +x "$REMOTE_DEPLOY_DIR/docker-compose-up.prepared.sh"


envsubst < "$REMOTE_DEPLOY_DIR/ubuntu/prepare.sh" > "$REMOTE_DEPLOY_DIR/ubuntu/prepare.prepared.sh"
chmod +x "$REMOTE_DEPLOY_DIR/ubuntu/prepare.sh"