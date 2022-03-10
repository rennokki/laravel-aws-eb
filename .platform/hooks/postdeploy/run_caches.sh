#!/bin/bash

# Run Caches

# After the deployment, it's highly recommended
# to re-run the caches for config, routes and views.

php artisan config:cache

php artisan route:cache

php artisan view:cache
