# from debian buster
FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

# make update, install dialog, apt-utils, mariadb, all php stuf, nginx and curl
RUN		apt-get update \
		&& apt-get -y --no-install-recommends install dialog apt-utils \
		mariadb-server \
		php7.3 php7.3-common php7.3-gd php7.3-mysql php7.3-imap php7.3-cli php7.3-cgi php-pear mcrypt imagemagick libruby php7.3-curl php7.3-intl php7.3-pspell php7.3-recode php7.3-sqlite3 php7.3-tidy php7.3-xmlrpc php7.3-xsl memcached php-memcache php-imagick php-gettext php7.3-zip php7.3-mbstring memcached php7.3-soap php7.3-fpm php7.3-opcache php-apcu \
		nginx \
		curl \
		&& apt-get clean

# untar and add wordpress / phpmyadmin directories
ADD		srcs/archives/wordpress-5.3.2-fr_FR.tar /var/www/html
ADD		srcs/archives/phpMyAdmin-4.9.0.1-all-languages.tar /usr/share

# rename phpMyAdmin-4.9.0.1-all-languages to phpmyadmin, change directory owner to www-data
RUN		mv /usr/share/phpMyAdmin-4.9.0.1-all-languages /usr/share/phpmyadmin \
		&& chown -R www-data:www-data /var/www/html/wordpress

# copy nginx directives file into nginx sites-available
COPY	srcs/nginx_directives /etc/nginx/sites-available/
# remove and make a new nginx directives symbolic link, rename index.nginx-debian.html to index.html
RUN		rm /etc/nginx/sites-enabled/default \
		&& ln -fs /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default \
		&& mv /var/www/html/index.nginx-debian.html /var/www/html/index.html

# add scripts directory into tmp
ADD	srcs/scripts /tmp/scripts

# start mysql to create wordpress db and the user with privileges for, make some settings for phpmyadmin and generate certificates
RUN		service mysql start \
		&& mysql -u root < /tmp/scripts/wp_queries.sql \
		&& sh /tmp/scripts/set_phpmyadmin_config_inc.sh \
		&& sh /tmp/scripts/generate_certificates.sh \
		&& service mysql stop

# expose http port
EXPOSE	80

# expose https port
EXPOSE	443

CMD		["/tmp/scripts/start_services.sh"]
