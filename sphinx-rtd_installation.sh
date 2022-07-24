#!/bin/bash

#NOTE: Requirements
apt update
apt install wget -y
apt install git -y
apt install nginx -y #NGINX HTTP server
apt install python3-sphinx -y # Sphinx base 
apt install python3-pip -y #Python pip
pip install sphinx-rtd-theme #Sphinx Read the Docs theme
pip install sphinx-autobuild #Sphinx autobuild package

#NOTE: Make base project directory
mkdir /docs

#NOTE: Execute sphinx-quickstart to build base documentation
sphinx-quickstart -q -p sphinx -a redteamcafe -v 0 --sep /docs

#NOTE: Add Read the Docs theme to conf.py
sed -i 's/alabaster/sphinx_rtd_theme/g' /docs/source/conf.py

#NOTE: Create sphinx-autobuild systemd service file
wget -P /etc/init.d <location>/autosphinx

#NOTE: Reload systemd


#NOTE: start and enable service
service start autosphinx.service



#NOTE: Create pip user (felt cute, might delete later)
#apt useradd sphinx -p sphinx
#NOTE: login as sphinx (non root) user for installing pip packages
#su sphinx
