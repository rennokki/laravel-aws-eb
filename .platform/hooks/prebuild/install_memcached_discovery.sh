#!/bin/sh

# Memcached Discovery is a Memcached extension that replace the default Memcached
# extension, so you can use the Discovery feature for AWS Memcached clusters.
# Just uncomment the following lines and
# MAKE SURE YOU RESTART PHP-FPM AND NGINX (please see
# the `restart_services.sh` file and enable the commands from there)
# See more about it here: https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/AutoDiscovery.HowAutoDiscoveryWorks.html

# cd /tmp

# wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-7.X/latest-64bit -O memcached.tar.gz

# tar -zxvf memcached.tar.gz

# sudo mv amazon-elasticache-cluster-client.so /usr/lib64/php/modules/

# Replace the memcached extension in php.d/* configuration
# sudo grep -q '^extension' /etc/php.d/50-memcached.ini && sudo sed -i 's/^extension.*/extension=amazon-elasticache-cluster-client.so/' /etc/php.d/50-memcached.ini || echo 'extension=amazon-elasticache-cluster-client.so' | sudo tee -a /etc/php.d/50-memcached.ini

# rm -rf memcached.tar.gz
