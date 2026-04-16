FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/front-page.conf /etc/nginx/sites-available/default
COPY www/ /var/www/front-page/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
