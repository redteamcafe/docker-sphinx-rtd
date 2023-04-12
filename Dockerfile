FROM alpine:latest

# Create docs directory and set as environment variable
ENV DOCS_DIR=/docs
ENV PROJECT_NAME=project
ENV PROJECT_AUTHOR=author
ENV PROJECT_RELEASE=1.0
ENV PUID=1000
ENV PGID=1000
RUN mkdir -p $DOCS_DIR

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

# Clone Sphinx documentation repository if DOCS_DIR is empty
RUN if [ -z "$(ls -A $DOCS_DIR)" ]; then \
    sphinx-quickstart --project="$PROJECT_NAME" --author="$PROJECT_AUTHOR" \
    --version="$PROJECT_RELEASE" \
    --sep --extensions=autoapi.extension \
    --extensions=sphinx.ext.autosectionlabel \
    --extensions=sphinx.ext.napoleon \
    --extensions=sphinx.ext.viewcode \
    --extensions=sphinx_rtd_theme \
    --sourcedir=source --no-batchfile \
    --confdir=source --no-makefile \
    $DOCS_DIR; \
fi

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Build Sphinx documentation
RUN cd $DOCS_DIR && \
    sphinx-autobuild . _build/html

# Set permissions for PUID and PGID
RUN chown -R $PUID:$PGID $DOCS_DIR

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
