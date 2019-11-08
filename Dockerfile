FROM python:3-alpine
MAINTAINER Richard Kojedzinszky <richard@kojedz.in>

ENV APP_USER=docker-registry-auth \
    APP_HOME=/opt/docker-registry-auth \
    AUTH_REVISION=3b89cde5a19271d347e736d83858278cbc254b43

RUN apk add --no-cache openssl supervisor nginx && \
	mkdir -p /data $APP_HOME && \
	adduser -D -H -h $APP_HOME $APP_USER

RUN apk add --no-cache -t .build-deps gcc make libffi-dev postgresql-dev curl tar libc-dev linux-headers && \
	cd /opt/docker-registry-auth && \
	curl -L https://github.com/rkojedzinszky/docker-registry-auth/archive/$AUTH_REVISION.tar.gz | tar xzf - --strip-components=1 && \
	pip install -U pip uwsgi -r requirements.txt && \
	apk del .build-deps && \
	python manage.py test && \
	python manage.py collectstatic --no-input && \
	rm -rf /root/.cache

ADD assets/ /

RUN chgrp $APP_USER $APP_HOME/local_settings.py

VOLUME /data

EXPOSE 80 8000

WORKDIR $APP_HOME

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
