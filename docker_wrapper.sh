#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PROJ=$(ls /sphinx/projects/ | tee /var/local/PROJ.txt)
PROJS=$(ls -A /sphinx/projects)

echo "==========================="
echo "STEP: CHECKING FOR PROJECTS"
echo "==========================="
echo "starting check for projects in /sphinx/projects"
if [[ -n "$PROJS" ]]
then
  echo "projects detected in /sphinx/projects"
else
  echo "this check failed because there are no projects detected in /sphinx/projects"
  echo "checking to see if there is a new project assigned to be created"
  if [[ -n "$PROJECT" ]]
  then
    echo "No projects were detected but a project $PROJECT is scheduled to be created"
  else
    echo "no projects detected in /sphinx/projects and no new projects are queued to be started"
    echo "please refer to the documentation for this container and check for errors"
    echo "exiting"
    exit 0
  fi
fi

#NOTE: You can add new projects to an already running Sphinx RTD container.
echo "============================="
echo "STEP: SETTING UP NEW PROJECTS"
echo "============================="
echo "checking for new projects with assigned variable name=$PROJECT_NAME author=$PROJECT_AUTHOR"
NEW_PROJ=/sphinx/projects/$PROJECT
if [[ -f "$NEW_PROJ/source/conf/py" ]]
then
   echo "detected file conf.py for project $PROJECT"
   echo "skipping $PROJECT"
else
  echo "project $PROJECT does NOT exist or there is no conf.py file found for project $PROJECT"
  echo "creating project $PROJECT"
  sphinx-quickstart -q -p "$PROJECT_NAME" -a "$PROJECT_AUTHOR" -v 0 --sep /sphinx/projects/$PROJECT
  sed -i "s|html_theme = 'alabaster'|html_theme = 'sphinx_rtd_theme'|g" /sphinx/projects/$PROJECT/conf.py
fi

echo "=============================="
echo "STEP: REMOVING DEFAULT PROJECT"
echo "=============================="
echo "assigning variable PROJ_NUM"
PROJ_NUM=$(ls /sphinx/projects | wc -l)
echo "PROJ_NUM set to $PROJ_NUM"
echo "assigning variable PROJ_NAME"
PROJ_NAME=$(ls /sphinx/projects)
echo "PRORJ_NAME set to $PROJ_NAME"
echo "checking to see if config file /sphinx/default/source/conf.py exists"
#NOTE: This step is done to clear default as a reset in the even that changes are made and only 1 project exists
if [[ -f "/sphinx/default/source/conf.py" ]]
then
  echo "conf.py detected, purging /sphinx/default"
  rm -r /sphinx/default
else
  echo "conf.py not detected for default"
fi

echo "================================"
echo "STEP: GENERATING DEFAULT PROJECT"
echo "================================"
echo "checking to see if there are more than 1 project"
echo "if more than 1 project exists"
if [[ "$PROJ_NUM" -gt "1" ]]
then
  echo "more than 1 project detected"
  echo "running sphinx-quickstart to generate project default"
  sphinx-quickstart -q -p sphinx -a sphinx -v 0 --sep /sphinx/default
  sed -i "s|html_theme = 'alabaster'|html_theme = 'sphinx_rtd_theme'|g" /sphinx/projects/$PROJECT/conf.py
  echo "copying indest.rst"
  rm /sphinx/default/source/index.rst && cp /sphinx/index.rst > /sphinx/default/source
else
  echo "project $PROJ_NAME exists as the only project"
fi

#NOTE: Autosphinx is started first in order to generate necessary HTML files required for the next step with NGINX
echo "======================"
echo "STEP: AUTOSPHINX START"
echo "======================"
echo "starting autosphinx"
service autosphinx start

echo "======================="
echo "STEP: CONFIGURING NGINX"
echo "======================="
echo "setting variable NGINX_CONF"
NGINX_CONF=$(grep -iRl 'listen 80' /etc/nginx/sites-available)
echo "configuring nginx"
if [[ -f '$NGINX_CONF' ]]
then
    echo "/etc/nginx/sites-available/default exists and is configured to use port 80"
    sed -i 's|root.*html;|root /sphinx/html;|g' /etc/nginx/sites-available/default
else
  sleep 0
fi

echo "====================================="
echo "STEP CONFIGURING HTML FILES FOR NGINX"
echo "====================================="
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
echo "==========================="
echo "STEP: STARTING NGINX SERVER"
echo "==========================="
echo "starting nginx service"
nginx -t
service nginx reload
service nginx start

#NOTE: This is for container persistence
/bin/bash
