[![pipeline status](https://gitlab.conarx.tech/containers/nginx-uwsgi/badges/main/pipeline.svg)](https://gitlab.conarx.tech/containers/nginx-uwsgi/-/commits/main)

# Container Information

[Container Source](https://gitlab.conarx.tech/containers/nginx-uwsgi) - [GitHub Mirror](https://github.com/AllWorldIT/containers-nginx-uwsgi)

This is the Conarx Containers Nginx UWSGI image, it provides the Nginx webserver bundled with UWSGI for serving of Python-based web
applications.



# Mirrors

|  Provider  |  Repository                                 |
|------------|---------------------------------------------|
| DockerHub  | allworldit/nginx-uwsgi                      |
| Conarx     | registry.conarx.tech/containers/nginx-uwsgi |



# Commercial Support

Commercial support is available from [Conarx](https://conarx.tech).



# Environment Variables

Additional environment variables are available from...
* [Conarx Containers Nginx image](https://gitlab.conarx.tech/containers/nginx)
* [Conarx Containers Postfix image](https://gitlab.conarx.tech/containers/postfix)
* [Conarx Containers Alpine image](https://gitlab.conarx.tech/containers/alpine).


## UWSGI_WORKERS

Number of UWSGI workers to spawn, defaults to `4`.


## UWSGI_MODULE

Application module to use, defaults to `app`.


## UWSGI_CALLABLE

UWSGI callable, defaults to `app`.



# Volumes


## /var/www/app

Application directory.



# Files & Directories


## /etc/uwsgi/uwsgi.ini

Main UWSGI configuration. This configuration file will also load `/etc/uwsgi/app.ini` which is where the application specifics can
be configured if the environment variable options are not sufficient.

## /etc/uwsgi/app.ini

App specific UWSGI configuration, a copy is included below for reference...
```ini
[uwsgi]

chdir = /var/www/app

if-dir = /var/www/virtualenv
virtualenv = /var/www/virtualenv
endif =

workers = 4
module = app
callable = app
```

Keeping in mind that the `workers`, `module` and `callable` can be customized using environment variables.


## /var/www/app/requirements.txt

If `/var/www/app/requirements.txt` exists and no `/var/www/virtualenv` exists, a virtual environment will be created using the
`requirements.txt` file.

The virtual environment can be persisted using a volume for `/var/www/virtualenv`.


## /var/www/app/static/

This directory will be served directly from Nginx bypassing UWSGI.


## /var/www/virtualenv/

If this directory exists it will be used as the virtualenv for the application. It will be automatically created if
`/var/www/app/requirements.txt` exists.



# Health Checks

Health checks are done by the underlying
[Conarx Containers Nginx image](https://gitlab.iitsp.com/allworldit/docker/nginx/README.md).
