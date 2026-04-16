# USER_DOC

## Overview

This stack provides the following services:

- NGINX: public HTTPS entrypoint on port 443
- WordPress (PHP-FPM): application service
- MariaDB: database service
- Front-page (bonus): static website service routed through NGINX at `/front-page/`

Only NGINX is exposed to the host network.

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

If the domain does not resolve, add a local hosts mapping to your machine IP.

## Credentials and Configuration

Configuration values are loaded from `srcs/.env`.

Important variables include:

- Database: `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`
- WordPress admin/user: `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_USER`, `WP_USER_PASSWORD`
- Domain: `DOMAIN_NAME`

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

Tail logs:

```bash
make logs
```
