#!/bin/sh

echo "Starting {{ app_name }} as `whoami`"

# Activate the virtual environment.
cd {{ app_project_dir }}
. {{ app_virtualenv_dir }}/bin/activate

# Set additional environment variables.
. {{ app_virtualenv_dir }}/bin/postactivate

# Programs meant to be run under supervisor should not daemonize themselves
exec python {{ app_name }}.py
