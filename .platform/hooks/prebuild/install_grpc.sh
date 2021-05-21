#!/bin/sh

# Some packages use PHP client libraries for gRPC-enabled APIs
# Uncomment the following lines to install gRPC on each deploy.

# set +e

# sudo amazon-linux-extras enable epel

# sudo yum clean metadata

# sudo yum install -y epel-release

# sudo yum install -y php-devel php-pear gcc zlib-devel

# printf '\n' | : sudo pecl install grpc
