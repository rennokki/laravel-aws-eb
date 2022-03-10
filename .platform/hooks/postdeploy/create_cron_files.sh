#!/bin/sh

# Create CRON files

# After the deployment finishes, set up a Crontab for
# the php artisan schedule:run command

echo "* * * * * root /usr/bin/php /var/app/current/artisan schedule:run 1>> /dev/null 2>&1" \
  | sudo tee /etc/cron.d/artisan_scheduler

# In some cases, Laravel logs a lot of data in the storage/logs/laravel.log and it sometimes
# might turn out into massive files that will restrict the filesystem.
# Uncomment the following lines to enable a CRON that deletes the laravel.log file
# every now and often.

# echo "0 0 * * */7 root rm -rf /var/app/current/storage/logs/laravel.log 1>> /dev/null 2>&1" \
#   | sudo tee /etc/cron.d/log_deleter
