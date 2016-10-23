FROM python:2-alpine
MAINTAINER Richard Kojedzinszky <krichy@nmdps.net>

ENV APP_USER=docker-registry-auth APP_HOME=/opt/docker-registry-auth

RUN apk add --no-cache openssl supervisor nginx && \
	mkdir -p /data $APP_HOME && \
	adduser -D -H -h $APP_HOME $APP_USER

RUN apk add --no-cache -t .build-deps gcc make libffi-dev postgresql-dev git libc-dev linux-headers && \
	git clone --depth 1 https://github.com/rkojedzinszky/docker-registry-auth $APP_HOME && \
	cd /opt/docker-registry-auth && \
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
