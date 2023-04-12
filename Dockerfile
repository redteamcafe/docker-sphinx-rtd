FROM alpine:latest

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

# Clone Sphinx documentation repository if DOCS is empty
RUN if [ ! -f "$DOCS/source/conf.py" ]; then \
    sphinx-quickstart -q \
    --p "$PROJECT_NAME" \
    -a "$PROJECT_AUTHOR" \
    -v "$PROJECT_RELEASE" \
    --sep $DOCS \
    --extensions=sphinx.ext.autosectionlabel \
    --extensions=sphinx.ext.napoleon \
    --extensions=sphinx.ext.viewcode \
    --extensions=sphinx_rtd_theme; \
fi

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Build Sphinx documentation
RUN cd $DOCS && \
    sphinx-autobuild . _build/html

# Set permissions for PUID and PGID
RUN chown -R $PUID:$PGID $DOCS

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
