#!/bin/bash
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

# If we have a requirements.txt file it can be assumed we need to setup a virtualenv
if [ -e /var/www/app/requirements.txt ]; then
	# If we have a bin directory, it's probably already set up
	if [ ! -d /var/www/app/virtualenv/bin ]; then
		fdc_notice "Downloading app depedencies..."
		python -m venv /var/www/virtualenv
		/var/www/virtualenv/bin/pip install -r /var/www/app/requirements.txt
	fi
fi