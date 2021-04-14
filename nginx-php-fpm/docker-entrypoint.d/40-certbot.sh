#!/bin/sh

if [[ -n "$NGINX_DOMAINS" -a -n "$CERTBOT_EMAIL" ]]; then
	certbot run --non-interactive --email "$CERTBOT_EMAIL" --agree-tos --nginx -d "$NGINX_DOMAINS";
fi