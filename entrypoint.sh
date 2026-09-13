#!/usr/bin/env sh
set -e

# Render (and most single-process PaaS targets) run this Dockerfile as ONE
# container with no docker-compose, so this script does what the django
# service in docker-compose.yml normally does for you: migrate the schema
# and load demo data, every boot. Vessel/SpillDetection.objects.update_or_create
# in seed_demo makes re-running this on every restart safe.
python backend/django/manage.py migrate --noinput
python backend/django/manage.py seed_demo

# Render injects $PORT and routes external traffic to whatever you bind to
# it -- a hardcoded 8000 will not necessarily be reachable, so default to
# 8000 only for local `docker run` and otherwise trust $PORT.
exec python -m uvicorn backend.app.main:app --host 0.0.0.0 --port "${PORT:-8000}"
