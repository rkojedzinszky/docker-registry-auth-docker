# docker-registry-auth-docker

docker-registry-auth dockerized

You can run this as:

```shell
$ docker run -v /local/data:/data -p 8080:80 authenticator
```

And first create a superuser account by:

```shell
$ docker run -it --rm -v /local/data:/data authenticator python manage.py createsuperuser
```

