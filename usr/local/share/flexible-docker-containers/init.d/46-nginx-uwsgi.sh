#!/bin/bash
# Copyright (c) 2022-2025, AllWorldIT.
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


fdc_notice "Initializing Nginx UWSGI settings"

# Check if we need to chagne the worker count
if [ -n "$UWSGI_WORKERS" ]; then
	sed -i -e "s/workers = 4/workers = $UWSGI_WORKERS/" /etc/uwsgi/app.ini
fi

# Check if we need to chagne the module
if [ -n "$UWSGI_MODULE" ]; then
	sed -i -e "s/module = app/workers = $UWSGI_MODULE/" /etc/uwsgi/app.ini
fi

# Check if we need to chagne the callable
if [ -n "$UWSGI_CALLABLE" ]; then
	sed -i -e "s/callable = app/callable = $UWSGI_CALLABLE/" /etc/uwsgi/app.ini
fi

# Decide what we're doing about the app environment
if [ ! -e /etc/uwsgi/uwsgi.env ]; then
	if set | grep -q -E '^UWSGI_ENV_'; then
		fdc_notice "Writing out custom Gunicorn environment variables"
		set | grep -E '^UWSGI_ENV_' | sed -e 's/^UWSGI_ENV_//' > /etc/uwsgi/uwsgi.env
	fi
fi
if [ -e /etc/uwsgi/uwsgi.env ]; then
	chown root:uwsgi /etc/uwsgi/uwsgi.env
	chmod 0640 /etc/uwsgi/uwsgi.env
fi
