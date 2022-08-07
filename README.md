[![redteamcafe.com](https://github.com/redteamcafe/docker-temp/raw/main/redteamcafe-logo.png)](https://redteamcafe.com)

Red Team Cafe is an organization dedicated to information technology and security.

We are proud to bring you one of our docker containers!

# [redteamcafe/docker-sphinx-rtd](https://github.com/redteamcafe/docker-sphinx-rtd)

[![Read the Docs](https://read-the-docs-guidelines.readthedocs-hosted.com/_downloads/731c436d154e84ae4d3c2430d62c6020/logo-wordmark-dark.svg)](https://readthedocs.org/)

## About this Build

* **Ubuntu** - This docker container is built on our base image of Ubuntu (in the future we are looking to change this to Alpine which is more lightweight).
* **Sphinx** - Sphinx is a free and open-source documentation generator that is written in Python. Sphinx utilized markdown language to write documents in reStructuredText files and then converts these to other formats such as HTML (for hosting on a webserver) as well as PDF and EPub. Sphinx is widely used for documenting code but can be used for anything to do with technical writing.
* **Read the Docs** - Read the Docs is essentially just a theme skinned for Sphinx that is widely used by technical writers and programmers. This allows documentation to be hosted locally instead of on Read the Docs servers.
* **Sphinx Autobuild** - This Python package is ran as a service in the Docker container. When enabled, it generates a server that monitors the source directory of the project. Whenever a change is detected, the source files are automatically built.
* **NGINX** - The webserver that hosts the HTML documentation files.
* 
Read the Docs is a free open-source documentation and hosting platform. Read the Docs can also be hosted locally as a theme using Sphinx. Read the Docs simplifies software documentation by automating building, versioning, and hosting of your docs. 

Currently supported:
* x86-64

# Deployment

## Docker Compose

```
docker run -it -d --name=sphinx-rtd redteamcafe/sphinx-rtd
```

## Docker CLI

*Prefered Method*

```
version: '3'

services:
  sphinx-rtd:
    image: redteamcafe/sphinx-rtd:latest
    container_name: sphinx-rtd
    environment:
      PROJECT_NAME: sphinx
      PROJECT_AUTHOR: sphinx
      PUID: 1000
      PGID: 1000
    volumes:
      - /docs
    ports:
      - 8080:80
    stdin_open: true # docker run -i
    tty: true        # docker run -t
    restart: unless-stopped
```
## Parameters
| Parameter | Function |
| :----: | --- |
| `-p 8080:80` | webserver port for accessing documentation |
| `-e PUID=1000` | set UserID |
| `-e PGID=1000` | set GroupID |
| `-e PROJECT_NAME` | name of the Sphinx project |
| `-e PROJECT_AUTHOR` | name of the Sphinx project author |
| `-v ./docs:/docs` | maps the directory where the documentation is stored |

# Future Contributions and Features
* Environmental variables that enable options for HTML, PDF and EPub documentation (when not declared, default to HTML)
* Environmental variables that allow Sphinx Autobuild to be disabled (when not declared, enable by default)



