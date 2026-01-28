FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	php-gd \
	php-xml \
	php-mbstring \
	curl \
	unzip \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY conf/php-fpm.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

EXPOSE 9000

CMD ["/usr/local/bin/init-wp.sh"]