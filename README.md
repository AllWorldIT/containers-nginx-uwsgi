# Introduction

This is a LEPF (Linux Nginx Python Flask) container for hosting various types of Flask apps.

Check the [Nginx Base Image](https://gitlab.iitsp.com/allworldit/docker/nginx/README.md) for more settings.

This image has a health check which checks `http://localhost` for a response.


# Configuration

## Python, UWSGI and Flask

The docker containr UWSGI settings are added as `/etc/uwsgi/uwsgi.ini`.

To specify custom settings you can bind mount this file.

The default module is `app` and the default callable is `app`.


