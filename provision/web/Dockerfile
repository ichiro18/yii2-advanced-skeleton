FROM php:7.3-fpm
MAINTAINER Ilya Zhuravlev <ichirozcom@gmail.com>

# Set working directory
WORKDIR /var/www

# Install common
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
    vim \
    unzip \
    git \
    curl \
    openssl

# Install PHP extensions dependencies
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
    # openssl
    libmcrypt-dev \
    libssl-dev \
    # pdo
    libzip-dev


# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring

# Install the xdebug extension
RUN pecl install xdebug

# Composer install
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Entrypoint
COPY /provision/web/entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r//' /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]
