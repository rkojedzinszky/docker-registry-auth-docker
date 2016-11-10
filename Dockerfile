FROM python:2-alpine
MAINTAINER Richard Kojedzinszky <krichy@nmdps.net>

ENV APP_USER=docker-registry-auth \
    APP_HOME=/opt/docker-registry-auth \
    AUTH_REVISION=d23ee8b79b3cb341a02ee656df1e1072668347b2

RUN apk add --no-cache openssl supervisor nginx && \
	mkdir -p /data $APP_HOME && \
	adduser -D -H -h $APP_HOME $APP_USER

RUN apk add --no-cache -t .build-deps gcc make libffi-dev postgresql-dev curl tar libc-dev linux-headers && \
	cd /opt/docker-registry-auth && \
	curl -L https://github.com/rkojedzinszky/docker-registry-auth/archive/$AUTH_REVISION.tar.gz | tar xzf - --strip-components=1 && \
	pip install -U pip uwsgi -r requirements.txt && \
	apk del .build-deps && \
	python manage.py collectstatic --no-input && \
	rm -rf /root/.cache

ADD assets/ /

RUN chgrp $APP_USER $APP_HOME/local_settings.py

VOLUME /data

EXPOSE 80

WORKDIR $APP_HOME

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
