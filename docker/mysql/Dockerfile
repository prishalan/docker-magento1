FROM alpine:latest

MAINTAINER Prishalan Naidoo "prishalan.naidoo@gmail.com"

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
		mysql \
		mysql-client \
		shadow

# Change mysql user and group IDs to match host uid & gid
RUN usermod -u ${U_ID} mysql \
	&& groupmod -g ${G_ID} mysql

# Create directories
RUN mkdir /scripts \
	&& mkdir /mysqldumps

# Clean up
RUN apk del --no-cache tzdata \
	&& rm -rf /var/cache/apk/*

# Create volume for databases
VOLUME ["/var/lib/mysql"]

# Copy scripts into image and set their permissions
COPY ./scripts/startup.sh /scripts/startup.sh
COPY ./scripts/mysqlimport.sh /scripts/mysqlimport.sh
COPY ./scripts/mysqlexport.sh /scripts/mysqlexport.sh

RUN chmod +x /scripts/*.sh \
	&& ln -s /scripts/mysqlimport.sh /usr/local/bin/mysqlimport \
	&& ln -s /scripts/mysqlexport.sh /usr/local/bin/mysqlexport

# Expose ports
EXPOSE 3306

# Set image entry-point
ENTRYPOINT ["/scripts/startup.sh"]