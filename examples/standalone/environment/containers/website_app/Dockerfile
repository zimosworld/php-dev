FROM zimosworld/php-dev:5.6
MAINTAINER "Jonathan Zimros <john@zimosworld.com>"

# Add in apache config file
ADD apache-config.conf /etc/httpd/conf.d/000-default.conf
# Add in entry point file
ADD docker-entrypoint.sh /docker-entrypoint.sh

# Add PHP.INI Configs
RUN echo "date.timezone=\"Australia/Sydney\"" >> /etc/php.ini

# Set working directory to where our files should be mounted
WORKDIR /var/www/html

# Expost ports 80 for http and 9000 for xdebug
EXPOSE 80 9000

ENTRYPOINT ["/docker-entrypoint.sh"]