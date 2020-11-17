#!/bin/bash

cat <<EOF > /var/www/app/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'TEST SUCCESS\n'
EOF

