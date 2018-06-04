FROM amazonlinux
MAINTAINER "Jonathan Zimros <john@zimosworld.com>"

RUN yum update -y

RUN yum install -y nano wget openssl

RUN yum remove -y httpd* php* && \
    yum install -y httpd22 \
        mod22_ssl \
        php \
        php-cli \
        php-common \
        php-devel \
        php-json \
        php-soap \
        php-mbstring \
        php-mcrypt \
        php-mysqlnd \
        php-xml \
        php-gd \
        php-process \
        php-pecl-redis \
        php-pecl-xdebug \
        php-pecl-zip && \
        yum clean all

# Add in entry point file
ADD docker-entrypoint.sh /docker-entrypoint.sh

#Fix an issue with nano
RUN export TERM=xterm

#enable xdebug
RUN echo 'xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}' >> /etc/php.ini
RUN echo 'xdebug.remote_host=${XDEBUG_REMOTE_HOST}' >> /etc/php.ini
RUN echo "xdebug.remote_enable=true" >> /etc/php.ini
RUN echo "xdebug.profiler_enable_trigger=true" >> /etc/php.ini
RUN echo "xdebug.profiler_output_dir=\"/var/www/html/environment/profiler_output\"" >> /etc/php.ini

# Update permissions on session folder so we can write to it
RUN chmod 777 /var/lib/php/session

WORKDIR /var/www/html

EXPOSE 80 9000

ENTRYPOINT ["/docker-entrypoint.sh"]