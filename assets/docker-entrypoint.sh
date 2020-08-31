#!/bin/sh

HOSTNAME=${HOSTNAME:-$(hostname -f)}
RSA_KEY=${RSA_KEY:-/data/key.pem}

umask 077

if [ ! -f "${RSA_KEY}" ]; then
	openssl genrsa -out "${RSA_KEY}" 4096
	chmod 640 "${RSA_KEY}"
	chgrp $APP_USER "${RSA_KEY}"
fi

su -c "python manage.py migrate" $APP_USER

exec "$@"
