FROM registry.gitlab.iitsp.com/allworldit/docker/alpine/v3.12:latest

ARG VERSION_INFO=
LABEL maintainer="Nigel Kukard <nkukard@LBSD.net>"

RUN set -ex; \
	true "Nginx"; \
	apk add --no-cache nginx; \
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stderr /var/log/nginx/error.log; \
	true "UWSGI-Python-Flask"; \
	apk add --no-cache uwsgi-python3 \
		py3-flask \
		py3-flask-wtf \
		curl \
		; \
	true "Users"; \
	adduser -u 82 -D -S -H -h /var/www/html -G www-data www-data; \
	true "Web root"; \
	mkdir -p /var/www/html; \
	chown www-data:www-data /var/www/html; chmod 0755 /var/www/html; \
	true "Web app"; \
	mkdir -p /var/www/app; \
	chown uwsgi:uwsgi /var/www/app; chmod 0755 /var/www/app; \
	true "Versioning"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*


# Nginx
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY init.d/50-nginx.sh /docker-entrypoint-init.d/50-nginx.sh
COPY pre-init-tests.d/50-nginx.sh /docker-entrypoint-pre-init-tests.d/50-nginx.sh
RUN set -eux; \
		chown root:root \
			/etc/nginx/nginx.conf \
			/etc/supervisor/conf.d/nginx.conf \
			/docker-entrypoint-init.d/50-nginx.sh \
			/docker-entrypoint-pre-init-tests.d/50-nginx.sh; \
		chmod 0644 \
			/etc/nginx/nginx.conf \
			/etc/supervisor/conf.d/nginx.conf; \
		chmod 0755 \
			/docker-entrypoint-init.d/50-nginx.sh \
			/docker-entrypoint-pre-init-tests.d/50-nginx.sh
EXPOSE 80

# PHP-FPM
COPY etc/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
#COPY etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf
COPY etc/supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
#COPY pre-init-tests.d/50-php-fpm.sh /docker-entrypoint-pre-init-tests.d/50-php-fpm.sh
#COPY tests.d/50-php-fpm.sh /docker-entrypoint-tests.d/50-php-fpm.sh
#COPY tests.d/52-php-fpm-with-ioncube.sh /docker-entrypoint-tests.d/52-php-fpm-with-ioncube.sh
RUN set -eux; \
		chown root:root \
			/etc/uwsgi/uwsgi.ini; \
		chmod 0644 \
			/etc/uwsgi/uwsgi.ini
#		chown root:root \
#			/etc/php7/conf.d/50-docker.ini \
#			/etc/php7/php-fpm.d/www.conf \
#			/etc/supervisor/conf.d/php-fpm.conf \
#			/docker-entrypoint-pre-init-tests.d/50-php-fpm.sh \
#			/docker-entrypoint-tests.d/50-php-fpm.sh; \
#		chmod 0644 \
#			/etc/php7/conf.d/50-docker.ini \
#			/etc/php7/php-fpm.d/www.conf \
#			/etc/supervisor/conf.d/php-fpm.conf; \
#		chmod 0755 \
#			/docker-entrypoint-pre-init-tests.d/50-php-fpm.sh \
#			/docker-entrypoint-tests.d/50-php-fpm.sh

# Health check
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

