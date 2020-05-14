#!/bin/sh

# Install Supervisor using the EPEL repository.

# This script will install Supervisor and configure your workers
# that are added in the .platform/files/supervisor.ini file.
# It's highly recommended to add all your workers in supervisor.ini
# to avoid conflicts for further updates.

# The `supervisorctl restart all` command will be
# triggered in the postdeploy hook to avoid
# any errors (the app is not set yet and
# it might trigger spawn errors, which will exit with non-zero code)

sudo amazon-linux-extras enable epel

sudo yum install -y epel-release

sudo yum -y update

sudo yum -y install supervisor

sudo systemctl start supervisord

sudo systemctl enable supervisord

sudo cp .platform/files/supervisor.ini /etc/supervisord.d/laravel.ini

sudo supervisorctl reread

sudo supervisorctl update
