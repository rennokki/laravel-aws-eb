#!/bin/sh

# Install PhpRedis

# Laravel uses by default PhpRedis, so the extension needs to be installed.
# https://github.com/phpredis/phpredis

# For Predis, this extension is not necessarily needed.
# Enabled by default since it's latest Laravel version's default driver.

sudo yum -y install php-redis
