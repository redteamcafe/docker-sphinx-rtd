#!/bin/bash

set -e

#NOTE: Start NGINX service
service nginx start &

#NOTE: Start autosphinx service
service autosphinx start &

exit 0
