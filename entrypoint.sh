#!/bin/bash
set -e

echo "SED"
# if first start, init conf
sed -i "s/\${DOMAIN}/${DOMAIN}/g" /var/lib/prosody/prosody.cfg.lua
sed -i "s/\${LDAP_ADMIN_DN}/${LDAP_ADMIN_DN}/g" /var/lib/prosody/prosody.cfg.lua
sed -i "s/\${LDAP_ADMIN_PASSWORD}/${LDAP_ADMIN_PASSWORD}/g" /var/lib/prosody/prosody.cfg.lua

echo "Start"
if [[ "$1" != "prosody" ]]; then
    exec prosodyctl $*
    exit 0;
fi

if [ "$LOCAL" -a  "$PASSWORD" -a "$DOMAIN" ] ; then
    prosodyctl register $LOCAL $DOMAIN $PASSWORD
fi

exec "$@"
