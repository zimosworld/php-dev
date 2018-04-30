FROM zimosworld/php-dev:5.6
MAINTAINER "Jonathan Zimros <john@zimosworld.com>"

# Add in apache config file
ADD apache-config.conf /etc/httpd/conf.d/000-default.conf

# Add PHP.INI Configs
RUN echo "date.timezone=\"Australia/Sydney\"" >> /etc/php.ini
