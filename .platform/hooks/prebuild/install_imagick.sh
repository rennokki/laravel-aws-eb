#!/bin/sh

# spatie/laravel-medialibrary needs Imagick installed.
# Uncomment the following lines to install Imagick on each deploy.

# Do not fail on any error. On PHP 7.3, it throws Segmentation Fault out of nowhere,
# altough the extension gets installed. Just as a safety measure.
# set +e

# sudo amazon-linux-extras enable epel

#sudo yum clean metadata

# sudo yum install -y epel-release

# sudo yum install -y ImageMagick ImageMagick-devel

# We use the noop ":" operator because on PHP 7.3,
# this command triggers segmentation fault altough
# the imagick PECL package gets installed.
# printf '\n' | : sudo pecl install imagick
