#!/bin/bash

set -e

#NOTE: Start NGINX service
exec service nginx start &

#NOTE: Start autosphinx service
exec service autosphinx start &

