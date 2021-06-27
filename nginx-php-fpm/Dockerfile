FROM registry.git.jeyserver.com/yeganemehr/dockerize:nginx-php7.4-alpine
ARG TSCONFIG_PATH=""
COPY --chown=www-data:www-data . /var/www/html
RUN rm -fr packages/dockerize; \
	find /var/www/html -type d -name ".docker" -prune -exec rm -fr {} \;; \
	if [[ -d /var/www/html/packages/node_webpack ]]; then \
		apk --no-cache add --virtual .webpack-deps nodejs npm; \
		cd packages/node_webpack/nodejs; \
		mkdir -p storage/public/frontend/dist; \
		npm start -- --skip-webpack; \
		if [[ -n "$TSCONFIG_PATH" ]]; then \
			npm start -- --webpack --tsconfig=$TSCONFIG_PATH; \
			NODE_ENV=production  npm start -- --webpack --production --tsconfig=$TSCONFIG_PATH; \
		else \
			npm start -- --webpack; \
			NODE_ENV=production  npm start -- --webpack --production; \
		fi; \
		find /var/www/html -type d -name "node_modules" -prune -exec rm -fr {} \;; \
		rm -fr /root/.npm /root/.config; \
		apk del --no-network .webpack-deps; \
	fi; \
	if [[ -d /var/www/html/packages/cronjob ]]; then \
		(crontab -u www-data -l 2>/dev/null; echo "* * * * * php /var/www/html/index.php --process=packages/cronjob/processes/cronjob@runTasks") | crontab -u www-data -; \
	fi; \
	(crontab -l 2>/dev/null; echo "0 0 * * * certbot renew") | crontab -;

VOLUME [ "/var/www/html/packages/base/storage", "/var/www/html/packages/userpanel/storage" ]
