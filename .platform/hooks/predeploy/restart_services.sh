#!/bin/sh

# This file will run restarts on specific services like PHP-FPM or NGINX.
# During prebuild, some PHP extensions might be installed and a restart
# might be needed.

# Out-of-the box, the extension installs are already loaded, so no need to do that.
# However, feel free to uncomment the following in case you have trust issues. ¯\_(ツ)_/¯

# sudo systemctl restart php-fpm.service

# sudo systemctl restart nginx.service
