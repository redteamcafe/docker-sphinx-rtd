#NOTE: This image uses Ubuntu as the source image available from Docker Hub

FROM ubuntu

MAINTAINER Christian McLaughlin <info@redteamcafe.com>

ENV PROJECT_NAME sphinx
ENV PROJECT_AUTHOR sphinx
ENV PUID 1000
ENV PGID 1000

SHELL ["/bin/bash", "-c"] 

#NOTE: Updating and installing required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    nginx \
    python3-pip \
    python3-sphinx \
    wget

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#NOTE: Installing required pip packages
RUN pip install sphinx-autobuild
RUN pip install sphinx-rtd-theme

#NOTE: Creates directory based on projects declared in the variable $PROJECT_NAME
#NOTE: For right now, I only support one project per container but in the future I am looking at incorporating multiple projects
RUN mkdir -p /docs/$PROJECT_NAME/

#NOTE: This checks for variables for PROJECT_AUTHOR and PROJECT_NAME and initiates Sphinx
RUN sphinx-quickstart -q -p $PROJECT_NAME -a $PROJECT_AUTHOR -v 0 --sep /docs/$PROJECT_NAME
RUN sed -i "s|html_theme = 'alabaster'|html_theme = 'sphinx_rtd_theme'|g" /docs/$PROJECT_NAME/source/conf.py

#NOTE: Startup
RUN wget -P /etc/init.d https://raw.githubusercontent.com/redteamcafe/docker-sphinx-rtd/main/autosphinx
RUN chmod +x /etc/init.d/autosphinx
RUN update-rc.d autosphinx defaults
RUN service autosphinx start &

#NOTE: Setting up NGINX root directory
RUN sed -i 's|root /var/www/html;|root /docs/sphinx/build/html;|g' /etc/nginx/sites-available/default
RUN nginx -t
RUN service nginx reload
RUN service nginx start

#Setting HTTP port and base project volume
EXPOSE 80
VOLUME /docs
