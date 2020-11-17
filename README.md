# Introduction

This is a LEPF (Linux Nginx Python Flask) container for hosting various types of Flask apps.

Check the [Alpine Base Image](https://gitlab.iitsp.com/allworldit/docker/alpine/README.md) for more settings.

This image has a health check which checks `http://localhost` for a response.


# Environment

## ENABLE_IONCUBE

If set to "yes", this will enable ionCube support.


# Configuration

## Nginx

By default nginx is configured to answer with 404 in `/etc/nginx/conf.d/default.conf`.

If you want to set a domain and have the default 404 for domains not configured then bind mount to
`/etc/nginx/conf.d/NAME.conf`.

Alternatively you can bind mount over `/etc/nginx/conf.d/default.conf`.

An example of a basic UWSGI configuration can be found below...
```
server {
	listen 80;
	server_name localhost;
	set_real_ip_from 172.16.0.0/12;

	location = /favicon.ico {
		log_not_found off;
		access_log off;
	}

	location = /robots.txt {
		allow all;
		log_not_found off;
		access_log off;
	}

	location ~* \.(js|css|gif|ico|jpg|jpeg|png)$ {
		expires max;
	}

	location / {
		# Pass request to UWSGI
		uwsgi_pass unix:/run/uwsgi.sock;

		# Include uwsgi_params settings
		include uwsgi_params;
	}

}
```

## Python, UWSGI and Flask

The docker containr UWSGI settings are added as `/etc/uwsgi/uwsgi.ini`.

To specify custom settings you can bind mount this file.

The default module is `app` and the default callable is `app`.


