FROM php:7.2-fpm AS php
COPY --chown=www-data:www-data ./simplephpapp /var/www/app
WORKDIR /var/www/app
RUN cp .env.example .env
RUN php artisan key:generate
