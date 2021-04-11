FROM registry.git.jeyserver.com/yeganemehr/dockerize:nginx-php7.4-alpine

COPY --chown=www-data:www-data . /var/www/html
RUN rm -fr packages/dockerize && \
	find /var/www/html -type d -name ".docker" -prune -exec rm -fr {} \; && \
	apk --no-cache add --virtual .webpack-deps nodejs npm && \
	cd packages/node_webpack/nodejs && \
	NODE_ENV=production  npm start -- --production && \
	find /var/www/html -type d -name "node_modules" -prune -exec rm -fr {} \; && \
	rm -fr /root/.npm /root/.config && \
	apk del --no-network .webpack-deps

VOLUME [ "/var/www/html/packages/base/storage", "/var/www/html/packages/userpanel/storage" ]
