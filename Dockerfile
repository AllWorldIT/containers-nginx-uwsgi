# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


FROM registry.conarx.tech/containers/nginx/3.19

ARG VERSION_INFO=
LABEL org.opencontainers.image.authors   "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   "3.19"
LABEL org.opencontainers.image.base.name "registry.conarx.tech/containers/nginx/3.19"


RUN set -eux; \
	true "UWSGI"; \
	apk add --no-cache \
		uwsgi-python3; \
	true "Web app"; \
	mkdir -p /app; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*


# We'll be using our own tests
RUN set -eux; \
	rm -f usr/local/share/flexible-docker-containers/pre-init-tests.d/44-nginx.sh


# Nginx - override the default vhost to include UWSGI support
COPY etc/nginx/http.d/50_vhost_default.conf.template /etc/nginx/http.d
COPY etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template /etc/nginx/http.d


# UWSGI
COPY etc/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY etc/uwsgi/app.ini /etc/uwsgi/app.ini
COPY etc/supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
COPY usr/local/sbin/start-uwsgi /usr/local/sbin
COPY usr/local/share/flexible-docker-containers/init.d/46-nginx-uwsgi.sh /usr/local/share/flexible-docker-containers/init.d
COPY usr/local/share/flexible-docker-containers/pre-init-tests.d/46-nginx-uwsgi.sh /usr/local/share/flexible-docker-containers/pre-init-tests.d
COPY usr/local/share/flexible-docker-containers/tests.d/46-nginx-uwsgi.sh /usr/local/share/flexible-docker-containers/tests.d
RUN set -eux; \
	true "Flexible Docker Containers"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	chown root:root \
		/app \
		/etc/nginx/http.d/50_vhost_default.conf.template \
		/etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template \
		/etc/uwsgi/uwsgi.ini \
		/usr/local/sbin/start-uwsgi; \
	chmod 0644 \
		/etc/nginx/http.d/50_vhost_default.conf.template \
		/etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template \
		/etc/uwsgi/uwsgi.ini; \
	chmod 0755 \
		/app \
		/usr/local/sbin/start-uwsgi; \
	true "Permissions"; \
	fdc set-perms
