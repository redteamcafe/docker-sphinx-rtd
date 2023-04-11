FROM alpine:latest

# Create docs directory and set as environment variable
ENV DOCS_DIR=/docs
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

# Clone Sphinx documentation repository
RUN git clone https://github.com/yourusername/your-repo.git $DOCS_DIR

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Build Sphinx documentation
RUN cd $DOCS_DIR && \
    sphinx-build -b html . _build/html

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
