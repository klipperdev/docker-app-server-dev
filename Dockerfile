FROM klipper-app-server:7.3.5

LABEL maintainer="François Pluchino <françois.pluchino@klipper.dev>"

# Add postgres dump and restore utilities
RUN apk update \
    && apk add --update --no-cache \
        postgresql-client \
        postgresql \
    && cp /usr/bin/pg_dump /usr/local/bin/pg_dump \
    && cp /usr/bin/pg_restore /usr/local/bin/pg_restore \
    && apk del --purge *-dev postgresql \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man

# Add PHP extensions
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        binutils-gold \
        g++ \
        gawk \
        gcc \
        libgcc \
        libtool \
        linux-headers \
        make \
    && pecl install xdebug-beta \
    #&& docker-php-ext-enable xdebug \
    && apk del --purge .build-deps *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man

# Add PHP config
COPY php.ini /usr/local/etc/php/conf.d/91_custom_dev.ini

# Add library dependencies for Yarn
RUN apk update \
    && apk add --update --no-cache \
        git \
        g++ \
        make \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man

# Add Nodejs and Yarn
RUN apk update \
    && apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
        nodejs-current>=12.2.0 \
        yarn>=1.16.0 \
    && apk del --purge *-dev postgresql \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man
