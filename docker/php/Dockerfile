FROM php:7.0-fpm-alpine

MAINTAINER "Prishalan Naidoo <prishalan.naidoo@gmail.com>"

# Timezone variable for SAST
ENV TIMEZONE Africa/Johannesburg

# Set build args
ARG U_ID
ARG G_ID

# Ready, set, go...
RUN apk update \
    && apk upgrade \
    && apk add --update tzdata \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && apk add --update --no-cache \
        zip \
        curl \
        libintl \
        libmcrypt \
        icu-dev \
        libmcrypt-dev \
        libxml2-dev \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        g++ \
        make \
        autoconf \
        supervisor \
    && docker-php-source extract \
    && pecl install \
        xdebug \
        redis \
    && docker-php-ext-enable \
        xdebug \
        redis \
    && docker-php-source delete \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NUMPROC} \
        gd \
        intl \
        zip \
        mcrypt \
        pdo_mysql \
        soap

# Copy configurations into image
COPY ./configs/php.ini /usr/local/etc/php/php.ini
COPY ./configs/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./configs/supervisord.conf /etc/supervisord.conf

# Configure Xdebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install N98-Magerun
RUN curl -O https://files.magerun.net/n98-magerun.phar \
    && chmod +x ./n98-magerun.phar \
    && mv n98-magerun.phar /usr/local/bin/magerun

# Fix www-data user permissions
RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --update add shadow@edge
RUN usermod -u ${U_ID} www-data \
    && groupmod -g ${G_ID} www-data

# Clean up
RUN apk del --no-cache tzdata shadow g++ make autoconf \
    && rm -rf /tmp/* /var/cache/apk/*

# Expose ports
EXPOSE 9000

# Set Working directory
WORKDIR /var/www/html

# Set user
USER www-data

# Run Supervisor
# CMD ["/usr/bin/supervisord"]