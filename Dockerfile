FROM php:7-apache
MAINTAINER codyrigg

RUN apt-get update && \
    apt-get install -y vim \
    curl \
    unzip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
	libldap2-dev&& \
    rm -rf /var/lib/apt/lists/* 
	
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
    
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir /var/www/parking && chown www-data: /var/www/parking -R && \
    chmod 0755 /var/www/parking -R
	
COPY ./config/parking.conf /etc/apache2/sites-available/parking.conf
RUN mkdir -p /var/www/parking/current

RUN a2ensite parking.conf && a2dissite 000-default.conf && a2enmod rewrite

WORKDIR /var/www/parking

EXPOSE 80

CMD ["apache2-foreground"]
