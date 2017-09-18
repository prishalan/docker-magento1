FROM nginx:1.12-alpine

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
    && echo "${TIMEZONE}" > /etc/timezone

# Ensure to use www-data user
RUN addgroup -g ${G_ID} -S www-data
RUN adduser -u ${U_ID} www-data -G www-data -H -s /bin/false -D

# Remove default Nginx site config
RUN rm /etc/nginx/conf.d/default.conf

# Add modified nginx configuration
COPY ./configs/nginx.conf /etc/nginx/nginx.conf

# Change ownerships
RUN touch /var/run/nginx.pid \
	&& chown -R www-data:www-data /var/run/nginx.pid \
	&& chown -R www-data:www-data /var/cache/nginx

# Clean up
RUN apk del --no-cache tzdata
RUN rm -rf /tmp/* /var/cache/apk/*

# Set volume
VOLUME /var/www/html

# Set user
USER www-data