#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then
    echo "Caching configuration..."
    (cd /var/www/zoom-recordings/current && php artisan config:cache && php artisan view:cache)
fi

if [ "$role" = "app" ]; then

    exec apache2-foreground

fi
