#!/bin/sh

# Add custom configuration to PHP

# The .platform/files/php.ini files contains enabled OP-cache
# configuration. Feel free to edit it in case you want custom configuration.

sudo cp .platform/files/php.ini /etc/php.d/laravel.ini
