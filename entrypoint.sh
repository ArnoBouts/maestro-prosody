#!/bin/bash
set -e

# if first start, init conf
sed -i "s/\${DOMAIN}/${DOMAIN}/1" /etc/prosody/prosody.cfg.lua

if [[ "$1" != "prosody" ]]; then
    exec prosodyctl $*
    exit 0;
fi

if [ "$LOCAL" -a  "$PASSWORD" -a "$DOMAIN" ] ; then
    prosodyctl register $LOCAL $DOMAIN $PASSWORD
fi

exec "$@"
