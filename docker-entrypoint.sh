#!/usr/bin/env bash
set -euo pipefail

if [ -n "${DJANGO_SUPERUSER_USERNAME:-}" ] && [ -n "${DJANGO_SUPERUSER_EMAIL:-}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD:-}" ]; then
  export DJANGO_SUPERUSER_CREDS=1
else
  unset DJANGO_SUPERUSER_CREDS
fi

python manage.py migrate --noinput --skip-checks

python - <<'PYTHON'
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'savannah.settings')

import django
django.setup()

from django.contrib.sites.models import Site

site_id = int(os.environ.get('SITE_ID', '1'))
site_domain = os.environ.get('DJANGO_SITE_DOMAIN', '127.0.0.1')
site_name = os.environ.get('DJANGO_SITE_NAME', 'Savannah Local')

Site.objects.update_or_create(
  id=site_id,
  defaults={
    'domain': site_domain,
    'name': site_name,
  },
)
PYTHON

if [ -n "${DJANGO_SUPERUSER_CREDS:-}" ]; then
  python - <<'PYTHON'
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'savannah.settings')

import django
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()
username = os.environ['DJANGO_SUPERUSER_USERNAME']
email = os.environ['DJANGO_SUPERUSER_EMAIL']
password = os.environ['DJANGO_SUPERUSER_PASSWORD']

user = User.objects.filter(username=username).first()
if user is None:
    User.objects.create_superuser(username=username, email=email, password=password)
else:
    user.email = email
    user.is_superuser = True
    user.is_staff = True
    user.set_password(password)
    user.save()
PYTHON
fi

exec "${@}"