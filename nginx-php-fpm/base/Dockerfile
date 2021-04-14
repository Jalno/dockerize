FROM php:7.4-fpm-alpine

RUN apk --no-cache add nginx certbot certbot-nginx && \
	apk --no-cache add --virtual .gettext gettext && \
	mv /usr/bin/envsubst /tmp/ && \
	\
	runDeps="$( \
		scanelf --needed --nobanner /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" && \
	apk add --no-cache $runDeps &&\
	apk del --no-network .gettext &&\
	mv /tmp/envsubst /usr/local/bin/ &&\
	mkdir /run/nginx /run/php && \
	{ \
		echo "[www]"; \
		echo "user = www-data"; \
		echo "group = www-data"; \
		echo "listen = /run/php/php7.4-fpm.sock"; \
		echo "listen.owner = www-data"; \
		echo "listen.group = nginx"; \
		echo "listen.mode = 660"; \
		echo "pm = ondemand"; \
		echo "pm.max_children = 100"; \
		echo "pm.process_idle_timeout = 20"; \
		echo "pm.max_requests = 500"; \
		echo "php_admin_value[open_basedir] = /var/www/html:/tmp/:/var/tmp/:/dev/urandom"; \
		echo "security.limit_extensions = .php"; \
	} |  tee /usr/local/etc/php-fpm.d/www.conf; \
	{ \
		echo '[global]'; \
		echo 'daemonize = no'; \
	} | tee /usr/local/etc/php-fpm.d/zz-docker.conf; \
	apk --no-cache add bzip2 libzip libxml2 libmemcached jpeg libpng freetype gmp libssh2 && \
	apk --no-cache add --virtual .buildDeps $PHPIZE_DEPS bzip2-dev zlib libxml2-dev libmemcached-dev jpeg-dev libpng-dev freetype-dev gmp-dev libzip-dev libssh2-dev && \
	docker-php-ext-configure gd \
		--prefix=/usr \
		--with-jpeg \
		--with-freetype && \
	docker-php-ext-install opcache exif soap bz2 gd gmp zip mysqli && \
	pecl install memcached-3.1.3 && \
	pecl install -a ssh2-1.2 && \
	docker-php-ext-enable memcached ssh2 && \
	apk del --no-network .buildDeps

COPY docker-entrypoint.sh /
COPY nginx-php-fpm/docker-entrypoint.d/ /docker-entrypoint.d
COPY nginx-php-fpm/nginx-templates/ /etc/nginx/templates

VOLUME [ "/etc/letsencrypt/" ]

WORKDIR /var/www/html
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "start" ]
EXPOSE 80 443