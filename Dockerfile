#This image uses Ubuntu as the source image available from Docker Hub
FROM ubuntu

MAINTAINER Christian McLaughlin <info@redteamcafe.com>

RUN \
#NOTE: Updating and installing required apt packages \
  echo "Updating" \
  apt update \
  apt install -y --no-install-recommends \
    git \
    nginx \
    python3-pip \
    python3-sphinx \
    wget && \
#NOTE: Installing required pip packages \
  pip install sphinx-autobuild \
  sphinx-rtd-theme && \
#NOTE: Creates directory based on projects declared in the variable $PROJECT_NAME \
#NOTE: For right now, I only support one project per container but in the future I am looking at incorporating multiple projects \
  mkdir /docs/$PROJECT_NAME/ && \
#NOTE: This checks for variables for PROJECT_AUTHOR and PROJECT_NAME \
  if [[ -v PROJECT_NAME ]]; \
  then \
  echo "Project name is $PROJECT_NAME" \
  else \
  PROJECT_NAME=sphinx ; \
  fi && \
  if [[ -v PROJECT_AUTHOR ]] ; \
  then \
  echo "Project author is $PROJECT_AUTHOR" \
  else \
  PROJECT_NAME=sphinx ; \
  fi && \
#NOTE: Initiate Sphinx Project \
  sphinx-quickstart -q -p $PROJECT_NAME -a $PROJECT_AUTHOR -v 0 --sep /docs/$PROJECT_NAME && \
#NOTE: Startup \
  wget -P /etc/init.d https://raw.githubusercontent.com/redteamcafe/docker-sphinx-rtd/main/autosphinx && \
  chmod +x /etc/init.d/autosphinx && \
  start /etc/init.d/autosphinx \
