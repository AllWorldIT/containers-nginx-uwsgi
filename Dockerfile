FROM registry.gitlab.iitsp.com/allworldit/docker/nginx:latest

ARG VERSION_INFO=
LABEL maintainer="Nigel Kukard <nkukard@LBSD.net>"

RUN set -ex; \
	true "UWSGI-Python-Flask"; \
	apk add --no-cache uwsgi-python3 \
		py3-flask \
		py3-flask-wtf \
		; \
	true "Web app"; \
	mkdir -p /var/www/app; \
	chown uwsgi:uwsgi /var/www/app; chmod 0755 /var/www/app; \
	true "Versioning"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*

# We'll be using our own tests
RUN set -eux; \
		rm -rf /var/www/html; \
		rm -f \
		/docker-entrypoint-tests.d/50-nginx.sh \
		/docker-entrypoint-pre-init-tests.d/50-nginx.sh

# Nginx
COPY etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
RUN set -eux; \
		chown root:root \
			/etc/nginx/conf.d/default.conf; \
		chmod 0644 \
			/etc/nginx/conf.d/default.conf

EXPOSE 80

# UWSGI
COPY etc/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY etc/supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
COPY pre-init-tests.d/50-uwsgi.sh /docker-entrypoint-pre-init-tests.d/50-uwsgi.sh
COPY tests.d/50-uwsgi.sh /docker-entrypoint-tests.d/50-uwsgi.sh
RUN set -eux; \
		chown root:root \
			/etc/uwsgi/uwsgi.ini \
			/etc/supervisor/conf.d/uwsgi.conf \
			/docker-entrypoint-pre-init-tests.d/50-uwsgi.sh \
			/docker-entrypoint-tests.d/50-uwsgi.sh; \
		chmod 0644 \
			/etc/uwsgi/uwsgi.ini \
			/etc/supervisor/conf.d/uwsgi.conf; \
		chmod 0755 \
			/docker-entrypoint-pre-init-tests.d/50-uwsgi.sh \
			/docker-entrypoint-tests.d/50-uwsgi.sh

# Health check
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

