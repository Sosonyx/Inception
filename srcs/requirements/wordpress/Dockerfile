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

EXPOSE 9000

RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["init-wp.sh"]