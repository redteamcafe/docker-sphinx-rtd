[![redteamcafe.com](https://github.com/redteamcafe/docker-temp/raw/main/redteamcafe-logo.png)](https://redteamcafe.com)

Red Team Cafe is an information technology and security consultation organization



# [redteamcafe/sphinx-rtd](https://github.com/redteamcafe/docker-sphinx-rtd)

[![Read the Docs](https://read-the-docs-guidelines.readthedocs-hosted.com/_downloads/731c436d154e84ae4d3c2430d62c6020/logo-wordmark-dark.svg)](https://readthedocs.org/)

## About this Build

Ubuntu
Sphinx
Read the Docs is a free open-source documentation and hosting platform. Read the Docs can also be hosted locally as a theme using Sphinx. Read the Docs simplifies software documentation by automating building, versioning, and hosting of your docs. 

Currently supported:
* x86-64

# Deployment

## Docker Compose
```

```
## Docker CLI
```

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





