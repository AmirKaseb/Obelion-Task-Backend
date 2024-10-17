# Use PHP 8.2 with Apache as the base image
FROM php:8.2-apache

# Install necessary PHP extensions and utilities
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Copy the application files into the container
COPY . .

# Install PHP dependencies (including Laravel)
RUN composer install --no-dev --optimize-autoloader

# Expose the Apache port
EXPOSE 80
