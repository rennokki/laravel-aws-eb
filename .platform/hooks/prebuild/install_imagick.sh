#!/bin/sh

# Some packages like spatie/laravel-medialibrary needs Imagick installed.
# Uncomment the following lines to install Imagick on each deploy.

# set +e

# sudo amazon-linux-extras enable epel

# sudo yum clean metadata

# sudo yum install -y epel-release

# sudo yum install -y ImageMagick ImageMagick-devel

# printf '\n' | : sudo pecl install imagick
