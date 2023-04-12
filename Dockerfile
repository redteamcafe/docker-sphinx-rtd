FROM alpine:latest

#MAINTAINER Christian McLaughlin <info@redteamcafe.com>

# Create docs directory and set as environment variable
ENV DOCS=/docs
ENV PROJECT_NAME=project
ENV PROJECT_AUTHOR=author
ENV PROJECT_RELEASE=1.0
ENV PUID=1000
ENV PGID=1000
RUN mkdir -p $DOCS

# Install necessary packages
RUN apk update && \
    apk add --no-cache \
    python3 \
    py3-pip \
    git \
    make \
    nginx \
    supervisor

# Install Sphinx and Readthedocs theme
RUN pip3 install sphinx sphinx_rtd_theme sphinx-autobuild

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Run quickstart if conf.py doesn't exist
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
