#!/bin/sh

echo "Starting {{ app_name }}_celery as `whoami`"

# Activate the virtual environment.
cd {{ app_project_dir }}
. {{ app_virtualenv_dir }}/bin/activate

# Set additional environment variables.
. {{ app_virtualenv_dir }}/bin/postactivate

# Programs meant to be run under supervisor should not daemonize themselves
exec celery worker \
    -n worker1@%h \
    --app {{ app_name }} \
    --loglevel DEBUG \
    --logfile {{ app_log_dir }}/celery.log \
    -Q {{ celery_queues | join(',') }} \
    --concurrency 10 \
    --pool eventlet \
    --events
