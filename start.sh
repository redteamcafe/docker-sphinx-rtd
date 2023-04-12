#!/bin/sh

if [ ! -f "$DOCS/source/conf.py" ]; then
    sphinx-quickstart -q \
    --p "$PROJECT_NAME" \
    -a "$PROJECT_AUTHOR" \
    -v "$PROJECT_RELEASE" \
    --sep $DOCS \
    --extensions=sphinx.ext.autosectionlabel \
    --extensions=sphinx.ext.napoleon \
    --extensions=sphinx.ext.viewcode \
    --extensions=sphinx_rtd_theme
else
    echo "conf.py already exists. Skipping sphinx-quickstart"
fi

# Set permissions for PUID and PGID
chown -R $PUID:$PGID $DOCS

# Build Sphinx documentation
cd $DOCS && sphinx-autobuild . _build/html

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
