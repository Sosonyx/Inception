# USER_DOC

## Overview

This stack provides the following services:

- NGINX: public HTTPS entrypoint on port 443
- WordPress (PHP-FPM): application service
- MariaDB: database service
- Front-page (bonus): static website service routed through NGINX at `/front-page/`
- Redis (bonus): object cache used internally by WordPress
- Adminer (bonus): database administration UI exposed on port 8080

NGINX is the only HTTPS-facing entrypoint. Adminer is reachable on its own HTTP port
as permitted by the bonus rules.

## Start and Stop the Project

From the repository root:

```bash
make
```

Useful lifecycle commands:

```bash
make up
make down
make status
make logs
```

For a full cleanup (including volumes):

```bash
make clean
```

## Access the Website and Admin Panel

Main website:

- `https://ihadj.42.fr/`

WordPress admin panel:

- `https://ihadj.42.fr/wp-admin`

Bonus static site:

- `https://ihadj.42.fr/front-page/`

Adminer (bonus):

- `http://ihadj.42.fr:8080/`
- Use server `mariadb`, the `MYSQL_USER` and `MYSQL_PASSWORD` from `srcs/.env`,
  and the database `MYSQL_DATABASE`.

If the domain does not resolve, add a local hosts mapping to your machine IP.

## Credentials and Configuration

Configuration values are loaded from `srcs/.env`.

Important variables include:

- Database: `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`
- WordPress admin/user: `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_USER`, `WP_USER_PASSWORD`
- Domain: `DOMAIN_NAME`
- Redis cache: `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

A template file is available at `srcs/.env.sample`.

## Health Checks and Verification

Check service status:

```bash
make status
```

Inspect containers directly:

```bash
docker ps
```

Test HTTPS entrypoint:

```bash
curl -k -I https://ihadj.42.fr/
```

Test static bonus route:

```bash
curl -k -I https://ihadj.42.fr/front-page/
```

Test Adminer:

```bash
curl -I http://ihadj.42.fr:8080/
```

Check the Redis cache from inside the container:

```bash
docker exec -it redis redis-cli -a "$REDIS_PASSWORD" ping
```

Check the WordPress object cache status:

```bash
docker exec -it wordpress wp redis status --path=/var/www/html --allow-root
```

Tail logs:

```bash
make logs
```
