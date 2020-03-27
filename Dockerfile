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

RUN mkdir /var/www/zoom_recordings && chown www-data: /var/www/zoom_recordings -R && \
    chmod 0755 /var/www/zoom_recordings -R
    
COPY ./config/zoom_recordings.conf /etc/apache2/sites-available/zoom_recordings.conf
COPY ./config/zoom_recordings.php.ini /etc/apache2/conf.d/zoom_recordings.php.ini

RUN a2ensite zoom_recordings.conf && a2dissite 000-default.conf && a2enmod rewrite
	
RUN mkdir -p /var/www/zoom_recordings/current/public

WORKDIR /var/www/zoom_recordings

EXPOSE 80

CMD ["apache2-foreground"]
