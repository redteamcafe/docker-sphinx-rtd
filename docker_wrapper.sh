#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PROJ=$(ls /sphinx/projects/ | tee /var/local/PROJ.txt)
CONF_PY=$(ls -A /sphinx/projects/*/source | grep -o conf.py | uniq)

if [[ "$CONF_PY" -eq "conf.py" ]]
then
  echo "projects detected containing"
else
  echo "no projects detected"
  echo "exiting"
  exit 0
fi

#NOTE: You can add new projects to an already running Sphinx RTD container.
echo "checking for new projects with assigned variable name=$PROJECT_NAME author=$PROJECT_AUTHOR"
NEW_PROJ=/sphinx/projects/$PROJECT
if [[ -f $NEW_PROJ ]]
then
   echo "detected conf.py for project $PROJECT.... skipping"
else
  echo "PROJECT $PROJECT does NOT exist"
  echo "creating project $PROJECT"
  sphinx-quickstart -q -p "$PROJECT_NAME" -a "$PROJECT_AUTHOR" -v 0 --sep /sphinx/projects/$PROJECT
  sed -i "s|html_theme = 'alabaster'|html_theme = 'sphinx_rtd_theme'|g" /sphinx/projects/$PROJECT/conf.py
fi

echo "checking projects in /sphinx/projects"
echo "assigning variable PROJ_NUM, PROJ_NAME, and PROJ_DEF"
PROJ_NUM=$(ls /sphinx/projects | wc -l)
PROJ_NAME=$(ls /sphinx/projects)
echo "checking to see if /sphinx/default/source/conf.py exists"
echo "if degault exists, purge"
if [[ -f "/sphinx/default/source/conf.py" ]]
then
  echo "purging default"
  rm -r /sphinx/default
echo "checking to see if there are more than 1 project"
echo "if more than 1 project exists"
if [[ "$PROJ_NUM" -gt "1" ]]
then
  echo "more than 1 project detected"
  echo "running sqphinx-quickstart to generate project default"
  sphinx-quickstart -q -p sphinx -a sphinx -v 0 --sep /sphinx/default
  sed -i "s|html_theme = 'alabaster'|html_theme = 'sphinx_rtd_theme'|g" /sphinx/projects/$PROJECT/conf.py
  echo "copying indest.rst"
  rm /sphinx/default/source/index.rst && cp /sphinx/index.rst > /sphinx/default/source
else
  echo "project $PROJ_NAME exists as the only project"
fi

#NOTE: Autosphinx is started first in order to generate necessary HTML files required for the next step with NGINX
echo "starting autosphinx"
service autosphinx start

#NOTE: Configuring NGINX
echo "setting variable NGINX_CONF"
NGINX_CONF=$(grep -iRl 'listen 80' /etc/nginx/sites-available)
echo "configuring nginx"
if [[ -f '$NGINX_CONF' ]]
then
    echo "/etc/nginx/sites-available/default exists and is configured to use port 80"
    sed -i 's|root.*html;|root /sphinx/html;|g' /etc/nginx/sites-available/default
else
  sleep 0
#NOTE: This loops exists for something planned later. 
#  mv $NGINX_CONF /etc/nginx/sites-available/$PROJ_NAME
#  sed -i 's|root /var/www/html;|root /sphinx/projects/$PROJ_NAME/build/html;|g' /etc/nginx/sites-available/$PROJ_NAME
# rm -rv !("$PROJ_NAME")
fi

#NOTE:
echo "purging /sphinx/html"
rm -r /sphinx/html/*
if [[ "$PROJ_NUM" -gt "1" ]]
then
  echo "configuring /etc/nginx/sites-available/default for DEFAULT"
  sed -i 's|root.*html;|root /sphinx/html;|g' /etc/nginx/sites-available/default
  echo ""
  while IFS= read -r LINE;
    do if [[ -f /sphinx/projects/$LINE/source.conf.py ]];
    then
      echo "creating symbolic link for sphinx/projects/$LINE/build/html to /sphinx/html/$LINE"
      ln -s /sphinx/projects/$LINE/build/html /sphinx/html/$LINE
    else
      echo "skipping $LINE"
    fi;
    done < /var/local/PROJ.txt
  while IFS= read -r LINE;
    do if [[ -f /sphinx/projects/$LINE/source.conf.py ]];
    then
      echo "creating hyperlink for $LINE in index.rst for DEFAULT"
      echo "`$LINE <./$LINE/index.html>`_" >> /sphinx/default/source/index.rst
    else
      echo "skipping $LINE"
    fi; done < /var/local/PROJ.txt
  echo "creating symbolic link for DEFAULT"
  ln -s /sphinx/default/build/html/index.html /sphinx/html
else
  echo "configuring /etc/nginx/sites-available/default for $PROJECT"
  sed -i 's|root.*html;|root /sphinx/projects/$PROJ_NAME/build/html;|g' /etc/nginx/sites-available/default
fi

#NOTE: Start NGINX
echo "starting nginx service"
nginx -t
service nginx reload
service nginx start

#NOTE: This is for container persistence
/bin/bash
