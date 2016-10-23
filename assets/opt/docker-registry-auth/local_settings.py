import os, sys, base64

DEBUG = False
ALLOWED_HOSTS = [os.environ['HOSTNAME']]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/db/db.sqlite3',
    }
}

RSA_KEY = os.environ['RSA_KEY']

SECRET_KEY = base64.b64encode(os.urandom(32))

del os, sys, base64
