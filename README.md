[![redteamcafe.com](https://github.com/redteamcafe/docker-temp/raw/main/redteamcafe-logo.png)](https://redteamcafe.com)

Red Team Cafe is an organization dedicated to information technology and security.

We are proud to bring you one of our docker containers!

# [redteamcafe/docker-sphinx-rtd](https://github.com/redteamcafe/docker-sphinx-rtd)

[![Read the Docs](https://read-the-docs-guidelines.readthedocs-hosted.com/_downloads/731c436d154e84ae4d3c2430d62c6020/logo-wordmark-dark.svg)](https://readthedocs.org/)

## About this Build

RedTeamCafe brings ReadTheDocs (a Sphinx theme) to Docker!



* **Sphinx** is a popular documentation tool for Python projects, but it can be used for other programming languages as well. Sphinx makes it easy to create beautiful, easy-to-navigate documentation for your project, with support for HTML, PDF, and other output formats. Sphinx uses reStructuredText, a markup language that is similar to Markdown, to format and structure the documentation.

* **Read the Docs** is a popular hosting platform for Sphinx documentation. It makes it easy to build and host documentation for your project, with features like versioning, search, and easy integration with GitHub and other source code repositories. With Read the Docs, you can publish your documentation online and make it available to your users with just a few clicks.

* **Nginx** is a high-performance, open-source web server software that can handle high traffic loads with low memory usage. It can serve as a web server, reverse proxy, load balancer, and HTTP cache, and supports multiple protocols including HTTP, HTTPS, SMTP, POP3, and IMAP. Its event-driven, asynchronous architecture makes it efficient at handling concurrent connections, and it can be extended with third-party modules to add additional functionality.

* **Sphinx Autobuild** is a Python tool that provides live reloading and rebuilding of Sphinx documentation. It allows you to view changes to your documentation in real-time as you make them, without the need to manually rebuild and refresh your browser. With Sphinx Autobuild, you can quickly iterate on your documentation and see the results immediately. It also includes a built-in web server, making it easy to view your documentation in a browser. Sphinx Autobuild is particularly useful for larger projects with complex documentation, as it can save a significant amount of time and effort during the documentation development process.

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



