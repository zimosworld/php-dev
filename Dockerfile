FROM amazonlinux
MAINTAINER "Jonathan Zimros <john@zimosworld.com>"

RUN yum update -y

RUN yum install -y nano wget openssl

RUN yum remove -y httpd* php* && \
    yum install -y httpd24 \
        mod24_ssl \
        phpc \
        php56-cli \
        php56-common \
        php56-devel \
        php56-json \
        php56-soap \
        php56-mbstring \
        php56-mcrypt \
        php56-mysqlnd \
        php56-xml \
        php56-gd \
        php56-process \
        php56-pecl-redis \
        php56-pecl-xdebug \
        php56-pecl-zip && \
        yum clean all

#Fix an issue with nano
RUN export TERM=xterm

#enable xdebug
RUN echo 'xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}' >> /etc/php.ini
RUN echo 'xdebug.remote_host=${XDEBUG_REMOTE_HOST}' >> /etc/php.ini
RUN echo "xdebug.remote_enable=true" >> /etc/php.ini
RUN echo "xdebug.profiler_enable_trigger=true" >> /etc/php.ini
RUN echo "xdebug.profiler_output_dir=\"/var/www/html/environment/profiler_output\"" >> /etc/php.ini

# Update permissions on session folder so we can write to it
RUN chmod 777 /var/lib/php/5.6/session

WORKDIR /var/www/html

EXPOSE 80 9000

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]