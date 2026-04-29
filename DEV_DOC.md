# DEV_DOC

## Environment Setup from Scratch

### Prerequisites

- Linux VM
- Docker Engine + Docker Compose plugin
- GNU Make
- A local domain entry (`<login>.42.fr`) mapped to your machine IP

### Initial directory setup

```bash
mkdir -p /home/ihadj/data/mariadb /home/ihadj/data/wordpress
```

### Configuration files

- Main compose file: `srcs/docker-compose.yml`
- Environment file: `srcs/.env`
- Example env: `srcs/.env.sample`

Optional local secrets files are stored in:

- `secrets/credentials.txt`
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`

## Build and Launch

From repository root:

```bash
make build
make up
```

Or full cycle:

```bash
make
```

## Service Management Commands

```bash
make status
make logs
make down
make clean
make re
```

Useful compose-level commands:

```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker compose -f srcs/docker-compose.yml config
```

## Data Persistence Details

Persistent data is configured through named volumes in `srcs/docker-compose.yml`:

- `mariadb_data` mounted at `/var/lib/mysql`
- `wordpress_html` mounted at `/var/www/html`

These are configured to store data under host paths:

- `/home/ihadj/data/mariadb`
- `/home/ihadj/data/wordpress`

Redis is used as an in-memory cache only and is intentionally configured without disk
persistence (`save ""`, `appendonly no`).

This ensures data survives container recreation and image rebuilds.

## Project Structure Notes

Core services:

- `srcs/requirements/mariadb`
- `srcs/requirements/wordpress`
- `srcs/requirements/nginx`

Bonus services:

- `srcs/requirements/front-page` (static site reverse-proxied through NGINX)
- `srcs/requirements/redis` (WordPress object cache)
- `srcs/requirements/adminer` (database admin UI)

NGINX routes:

- `/` -> WordPress/PHP-FPM
- `/front-page/` -> front-page service via reverse proxy

Adminer is exposed directly on host port `8080` (extra port allowed by the bonus rules).

## Redis Object Cache Integration

- The WordPress image installs `php-redis`.
- `init-wp.sh` writes `WP_REDIS_HOST`, `WP_REDIS_PORT`, `WP_REDIS_PASSWORD` and `WP_CACHE`
  into `wp-config.php` at first install.
- The `redis-cache` plugin is installed and activated, and the drop-in is enabled with
  `wp redis enable`.

To inspect the cache:

```bash
docker exec -it wordpress wp redis status --path=/var/www/html --allow-root
docker exec -it redis redis-cli -a "$REDIS_PASSWORD" info stats
```

## Troubleshooting

If domain access fails:

1. Verify running services: `make status`
2. Validate HTTPS locally: `curl -k -I https://localhost/`
3. Ensure local DNS/hosts maps `ihadj.42.fr` to your machine IP

If WordPress cannot connect to MariaDB:

1. Check MariaDB health: `docker logs mariadb`
2. Confirm env values in `srcs/.env`
3. Recreate stack after config changes: `make re`

If Redis cache does not respond:

1. Check Redis logs: `docker logs redis`
2. Confirm `REDIS_PASSWORD` matches in `srcs/.env` and `wp-config.php`
3. Re-enable the drop-in: `docker exec wordpress wp redis enable --path=/var/www/html --allow-root`

If Adminer is unreachable:

1. Confirm port 8080 is free on the host
2. Check container health: `docker ps --filter name=adminer`
