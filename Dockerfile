# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies and PHP extensions required by Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev git unzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer (a PHP dependency manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy Laravel project into the container
COPY . .

# Set the correct permissions for Laravel files
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Install Composer dependencies
RUN composer install --no-interaction --optimize-autoloader

# Configure Apache to serve the Laravel public directory
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Expose the necessary port
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
