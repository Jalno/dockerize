#!/bin/sh

if ! command -v docker &> /dev/null; then
	apt-get update -y;
	DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common git;
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable";
	apt-get install -y docker-ce docker-ce-cli containerd.io
fi


if ! command -v docker-compose &> /dev/null; then
	curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
fi

mkdir -p $PRODUCTION_APP_PATH