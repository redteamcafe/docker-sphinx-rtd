#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RTD_CONF=/docs/source/conf.py

#NOTE: Sphinx Quikstart in the event that no source is detected
if [[ -f $RTD_CONF ]]
then
   echo "conf.py exists"
else
  echo "conf.py does NOT exist"
  sphinx-quickstart -q -p "$PROJECT_NAME" -a "$PROJECT_AUTHOR" -v 0 --sep /docs/
fi

#NOTE: Start NGINX
service nginx start

#NOTE: Start autosphinx
service autosphinx start


/bin/bash
