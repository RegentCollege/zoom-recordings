FROM php:7.4-apache
MAINTAINER ctucker

RUN apt-get update && \
    apt-get install -y vim \
    curl \
    unzip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libicu-dev \
    g++ 
    
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

RUN mkdir /var/www/zoom-recordings && chown www-data: /var/www/zoom-recordings -R && \
    chmod 0755 /var/www/zoom-recordings -R
    
COPY ./config/zoom-recordings.conf /etc/apache2/sites-available/zoom-recordings.conf
COPY ./config/zoom-recordings.php.ini /etc/apache2/conf.d/zoom-recordings.php.ini

RUN a2ensite zoom-recordings.conf && a2dissite 000-default.conf && a2enmod rewrite
	
RUN mkdir -p /var/www/zoom-recordings/current

WORKDIR /var/www/zoom-recordings

EXPOSE 80

CMD ["apache2-foreground"]
