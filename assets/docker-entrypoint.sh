#!/bin/sh

HOSTNAME=${HOSTNAME:-$(hostname -f)}
RSA_KEY=${RSA_KEY:-/data/signer.rsa.pem}
UWSGI_WORKERS=${UWSGI_WORKERS:-$(getconf _NPROCESSORS_ONLN)}
UWSGI_CHEAPER=${UWSGI_CHEAPER:-1}
UWSGI_CHEAPER_ALGO=${UWSGI_CHEAPER_ALGO:-busyness}
UWSGI_CHEAPER_OVERLOAD=${UWSGI_CHEAPER_OVERLOAD:-10}

mkdir -p /data/db

chown -R $APP_USER: /data/db

PYTHONHASHSEED=random

export HOSTNAME RSA_KEY PYTHONHASHSEED
export UWSGI_WORKERS UWSGI_CHEAPER UWSGI_CHEAPER_ALGO UWSGI_CHEAPER_OVERLOAD

umask 077

if [ ! -f "${RSA_KEY}" ]; then
	openssl genrsa -out "${RSA_KEY}" 4096
	chmod 640 "${RSA_KEY}"
	chgrp $APP_USER "${RSA_KEY}"
fi

su -c "python manage.py migrate" $APP_USER

exec "$@"

#exec uwsgi --wsgi dra.wsgi \
#	--uid $APP_USER \
#	--gid $APP_USER \
#	--static-map /static=$APP_HOME/static \
#	--master \
#	--threads 2 \
#	--workers ${UWSGI_WORKERS} \
#	--cheaper ${UWSGI_CHEAPER} \
#	--cheaper-algo ${UWSGI_CHEAPER_ALGO} \
#	--cheaper-overload ${UWSGI_CHEAPER_OVERLOAD} \
#	--http :8000
#else
#fi
