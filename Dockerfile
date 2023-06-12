# Use an official PHP runtime as a parent image
FROM php:8.2.3-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && \
  apt-get install -y libpq-dev && \
  apt-get install -y zlib1g-dev libicu-dev g++

# Install PHP extensions
RUN docker-php-ext-configure intl && \
  docker-php-ext-install pdo pdo_mysql intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Laravel source code to the container
COPY . /var/www/html

# Install Laravel dependencies
RUN composer install --no-dev

# Set up Apache
COPY ./apache2.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]