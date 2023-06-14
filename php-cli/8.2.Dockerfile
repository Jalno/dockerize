FROM ghcr.io/dnj/php-alpine:8.2-mysql
COPY --chown=www-data:www-data . /var/www/html
RUN rm -fr packages/dockerize; \
	find /var/www/html -type d -name ".docker" -prune -exec rm -fr {} \;; \
	if [[ -d /var/www/html/packages/cronjob ]]; then \
		(crontab -u www-data -l 2>/dev/null; echo "* * * * * php /var/www/html/index.php --process=packages/cronjob/processes/cronjob@runTasks") | crontab -u www-data -; \
	fi;
