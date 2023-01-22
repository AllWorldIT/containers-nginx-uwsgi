[![pipeline status](https://gitlab.conarx.tech/containers/nginx-uwsgi/badges/main/pipeline.svg)](https://gitlab.conarx.tech/containers/nginx-uwsgi/-/commits/main)

# Container Information

[Container Source](https://gitlab.conarx.tech/containers/nginx-uwsgi) - [GitHub Mirror](https://github.com/AllWorldIT/containers-nginx-uwsgi)

This is the Conarx Containers Nginx UWSGI image, it provides the Nginx webserver bundled with UWSGI for serving of Python-based web
applications.

Support is included for downloading and installing requirements listed in `requirements.txt` and optionally persisting these across
container restarts.

Static files are by default served by Nginx directly if placed in the `static/` folder of an application.



# Mirrors

|  Provider  |  Repository                                 |
|------------|---------------------------------------------|
| DockerHub  | allworldit/nginx-uwsgi                      |
| Conarx     | registry.conarx.tech/containers/nginx-uwsgi |



# Conarx Containers

All our Docker images are part of our Conarx Containers product line. Images are generally based on Alpine Linux and track the
Alpine Linux major and minor version in the format of `vXX.YY`.

Images built from source track both the Alpine Linux major and minor versions in addition to the main software component being
built in the format of `vXX.YY-AA.BB`, where `AA.BB` is the main software component version.

Our images are built using our Flexible Docker Containers framework which includes the below features...

- Flexible container initialization and startup
- Integrated unit testing
- Advanced multi-service health checks
- Native IPv6 support for all containers
- Debugging options



# Community Support

Please use the project [Issue Tracker](https://gitlab.conarx.tech/containers/nginx-uwsgi/-/issues).



# Commercial Support

Commercial support for all our Docker images is available from [Conarx](https://conarx.tech).

We also provide consulting services to create and maintain Docker images to meet your exact needs.



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



# Exposed Ports

Postfix port 25 is exposed by the [Conarx Containers Postfix image](https://gitlab.conarx.tech/containers/postfix) layer.

Nginx port 80 is exposed by the [Conarx Containers Nginx image](https://gitlab.conarx.tech/containers/nginx) layer.



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
