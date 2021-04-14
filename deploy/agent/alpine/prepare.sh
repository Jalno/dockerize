#!/bin/sh

apk add openssh-client gettext
eval "$(ssh-agent -s)"
echo "$SSH_PRODUCTION_PRIVATE_KEY" | tr -d '\r' | ssh-add -
mkdir -p ~/.ssh
chmod 700 ~/.ssh
if [[ -f /.dockerenv ]]; then 
	echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
fi
