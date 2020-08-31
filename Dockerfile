FROM rkojedzinszky/alpine-python-grpcio:3.12
MAINTAINER Richard Kojedzinszky <richard@kojedz.in>

ENV APP_USER=docker-registry-auth \
    APP_HOME=/opt/docker-registry-auth \
    AUTH_REVISION=7b2c214450fc0aee764966d4083c7454a7765e87

RUN apk add --no-cache openssl supervisor nginx py3-psycopg2 uwsgi-python3 openssl \
        py3-cryptography py3-jwt && \
	mkdir -p /data $APP_HOME && \
	adduser -D -H -h $APP_HOME $APP_USER

RUN apk add --no-cache -t .build-deps curl tar && \
	cd /opt/docker-registry-auth && \
	curl -L https://github.com/rkojedzinszky/docker-registry-auth/archive/$AUTH_REVISION.tar.gz | tar xzf - --strip-components=1 && \
	pip install -r requirements.txt && \
	apk del .build-deps && \
	python manage.py collectstatic --no-input && \
	rm -rf /root/.cache && \
	ln -sf /data/local_settings.py

ADD assets/ /

EXPOSE 80

WORKDIR $APP_HOME

ENV UWSGI_THREADS 4

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
