#!/bin/sh

# Install PhpRedis

# Laravel uses by default PhpRedis, so the extension needs to be installed.
# https://github.com/phpredis/phpredis

# For Predis, this extension is not necessarily needed.
# Enabled by default since it's latest Laravel version's default driver.

sudo yum -y install php-redis

# For PHP 8.0+, you can use the pecl command to install it. You may disable the previous command.

# pecl install redis
# sed -i -e '/extension="redis.so"/d' /etc/php.ini
# echo 'extension="redis.so"' > /etc/php.d/41-redis.ini
