#!/bin/sh

# Create CRON files

# After the deployment finishes, set up a Crontab for
# the php artisan schedule:run command

echo "* * * * * root /usr/bin/php /var/app/current/artisan schedule:run 1>> /dev/null 2>&1" \
    | sudo tee /etc/cron.d/artisan_scheduler

