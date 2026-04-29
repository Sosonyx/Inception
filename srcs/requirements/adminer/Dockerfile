FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-cli \
    php-mysql \
    php-mbstring \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/adminer \
    && curl -L https://www.adminer.org/latest.php -o /var/www/adminer/index.php

WORKDIR /var/www/adminer

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
