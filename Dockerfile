# Use an official PHP-FPM image as the base
FROM php:8.2-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Install system dependencies for Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql zip

# Install Composer
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# Copy composer.json and composer.lock first
COPY composer.json composer.lock ./

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Copy the application source code
# This should happen after composer install, so that the vendor directory
# is not overwritten if it was created by composer.
COPY src/ .

# Expose port 9000 for PHP-FPM
EXPOSE 9000
