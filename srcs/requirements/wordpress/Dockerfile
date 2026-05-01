FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	php-cli \
	php-redis \
	iproute2 \
	curl \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

COPY conf/php-fpm.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init-wp.sh /usr/local/bin/init-wp.sh

RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["/usr/local/bin/init-wp.sh"]