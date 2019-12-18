#!/bin/sh

echo "Starting {{ app_name }} as `whoami`"

# Activate the virtual environment.
cd {{ app_project_dir }}
. {{ app_virtualenv_dir }}/bin/activate

# Set additional environment variables.
. {{ app_virtualenv_dir }}/bin/postactivate

# Programs meant to be run under supervisor should not daemonize themselves
# (do not use --daemon).
exec gunicorn \
    --name {{ app_name }} \
    --workers {{ gunicorn_num_workers }} \
    --max-requests {{ gunicorn_max_requests }} \
    --timeout {{ gunicorn_timeout_seconds }} \
    --user {{ app_user }} \
    --group {{ app_group }} \
    --log-level debug \
    --bind unix:{{ app_run_dir }}/gunicorn.sock \
{% if gunicorn_reload_workers %}
    --reload \
{% endif %}
    {{ app_wsgi_module }}
