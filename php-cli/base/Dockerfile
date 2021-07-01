FROM php:7.4-cli-alpine

RUN apk --no-cache add bzip2 libzip libxml2 libmemcached jpeg libpng freetype gmp libssh2 && \
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
WORKDIR /var/www/html
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "start" ]