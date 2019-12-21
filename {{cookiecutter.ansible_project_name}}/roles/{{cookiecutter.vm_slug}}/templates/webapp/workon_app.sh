#!/bin/sh

cd {{ app_project_dir }}
. {{ app_virtualenv_dir }}/bin/activate
. {{ app_virtualenv_dir }}/bin/postactivate
