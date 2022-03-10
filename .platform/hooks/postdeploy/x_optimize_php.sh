#!/bin/bash

# This file will make sure that will set the max processes and spare processes
# according to the details provided by this machine instance.

DEFAULT_PROCESS_MEMORY="120"
MAX_REQUESTS="500"

PROCESS_MAX_MB=$(ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d\n", sum/NR/1024) }') || $DEFAULT_PROCESS_MEMORY

VCPU_CORES=$(($(lscpu | awk '/^CPU\(s\)/{ print $2 }')))

TOTAL_MEMORY_IN_KB=$(free | awk '/^Mem:/{print $2}')
USED_MEMORY_IN_KB=$(free | awk '/^Mem:/{print $3}')
FREE_MEMORY_IN_KB=$(free | awk '/^Mem:/{print $4}')

TOTAL_MEMORY_IN_MB=$(($TOTAL_MEMORY_IN_KB / 1024))
USED_MEMORY_IN_MB=$(($USED_MEMORY_IN_KB / 1024))
FREE_MEMORY_IN_MB=$(($FREE_MEMORY_IN_KB / 1024))

MAX_CHILDREN=$(($FREE_MEMORY_IN_MB / $PROCESS_MAX_MB))

# Optimal would be to have at least 1/4th of the children filled with children waiting to serve requests.
START_SERVERS=$(($MAX_CHILDREN / 4))
MIN_SPARE_SERVERS=$(($MAX_CHILDREN / 4))

# Optimal would be to have at most 3/4ths of the children filled with children waiting to serve requests.
MAX_SPARE_SERVERS=$(((3 * $MAX_CHILDREN) / 4))

sudo sed -i "s|pm.max_children.*|pm.max_children = $MAX_CHILDREN|g" /etc/php-fpm.d/www.conf
sudo sed -i "s|pm.start_servers.*|pm.start_servers = $START_SERVERS|g" /etc/php-fpm.d/www.conf
sudo sed -i "s|pm.min_spare_servers.*|pm.min_spare_servers = $MIN_SPARE_SERVERS|g" /etc/php-fpm.d/www.conf
sudo sed -i "s|pm.max_spare_servers.*|pm.max_spare_servers = $MAX_SPARE_SERVERS|g" /etc/php-fpm.d/www.conf

printf "\npm.max_requests = $MAX_REQUESTS" | sudo tee -a /etc/php-fpm.d/www.conf

# Restarting the services afterwards.
sudo systemctl restart php-fpm.service
sudo systemctl restart nginx.service
