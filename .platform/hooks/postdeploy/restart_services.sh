#!/bin/sh

# This file will run restarts on specific services like PHP-FPM or NGINX.
# During prebuild, some PHP extensions might be installed and a restart
# might be needed.

# We make sure to restart the services to take in consideration the new
# custom config

sudo systemctl restart php-fpm.service

sudo systemctl restart nginx.service
