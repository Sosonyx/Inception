FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx openssl curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=localhost" \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt

COPY conf/nginx.conf /etc/nginx/nginx.conf
# COPY tools/health-check.sh /usr/local/bin/health-check.sh
# RUN chmod +x /usr/local/bin/health-check.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]