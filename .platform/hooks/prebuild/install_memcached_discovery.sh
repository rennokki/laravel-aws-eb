#!/bin/sh

# Memcached Auto Discovery is a Memcached extension that replace the default Memcached
# extension, so you can use the Auto Discovery feature for AWS Memcached clusters.
# Just uncomment the following lines and MAKE SURE YOU RESTART PHP-FPM AND NGINX (please see
# the `restart_services.sh` file and enable the commands from there).
# See more about it here: https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/AutoDiscovery.HowAutoDiscoveryWorks.html

# cd /tmp

# Change `7.4` from below with your PHP version.
# For a list of PHP versions, check the following link (you should be logged in your AWS account): https://console.aws.amazon.com/elasticache/home#client-download:
# Follow the official repo here: https://github.com/awslabs/aws-elasticache-cluster-client-memcached-for-php
# The following examples are for both ARM and X86, so make sure to use the right version by uncommenting one of the following lines
# or by replacing your own PHP version with it.

# wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-7.4/latest-64bit-arm -O memcached.tar.gz
# wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-7.4/latest-64bit-X86 -O memcached.tar.gz

# tar -zxvf memcached.tar.gz

# sudo mv amazon-elasticache-cluster-client.so /usr/lib64/php/modules/

# sudo grep -q '^extension' /etc/php.d/50-memcached.ini && sudo sed -i 's/^extension.*/extension=amazon-elasticache-cluster-client.so/' /etc/php.d/50-memcached.ini || echo 'extension=amazon-elasticache-cluster-client.so' | sudo tee -a /etc/php.d/50-memcached.ini

# rm -rf memcached.tar.gz
