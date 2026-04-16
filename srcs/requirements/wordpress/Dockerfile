FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	php-gd \
	php-xml \
	php-mbstring \
	php-cli \
	iproute2 \
	curl \
	unzip \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

COPY conf/php-fpm.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init-wp.sh /usr/local/bin/init-wp.sh

RUN chmod +x /usr/local/bin/init-wp.sh
#  /usr/local/bin/health-check.sh
EXPOSE 9000

CMD ["/usr/local/bin/init-wp.sh"]