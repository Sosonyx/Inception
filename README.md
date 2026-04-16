*This project has been created as part of the 42 curriculum by ihadj.*

## Description

Inception is a system administration project focused on container orchestration with Docker Compose.
The goal is to deploy a secure multi-service web stack where each service runs in its own container and
communicates through an isolated Docker network.

This repository contains:

- An NGINX container (TLS entrypoint on port 443)
- A WordPress + PHP-FPM container
- A MariaDB container
- Persistent storage for both database data and WordPress files
- A bonus static website served from a dedicated container and exposed through NGINX

## Instructions

### Prerequisites

- Linux host / VM with Docker Engine and Docker Compose plugin installed
- A configured local domain mapping (for example `ihadj.42.fr`) to your machine IP
- Write access to `/home/<login>/data` for persistent volumes

### Setup

1. Create persistence directories:

```bash
mkdir -p /home/ihadj/data/mariadb /home/ihadj/data/wordpress
```

2. Prepare your environment variables file in `srcs/.env` (based on `srcs/.env.sample`).

3. Build and start:

```bash
make
```

### Common commands

```bash
make build     # Build images
make up        # Start services
make down      # Stop services
make logs      # Follow logs
make status    # Show service status
make clean     # Stop + remove volumes + prune images/cache
make re        # Full rebuild cycle
```

### Access

- Main website (WordPress): `https://ihadj.42.fr/`
- Bonus static website (through NGINX reverse proxy): `https://ihadj.42.fr/front-page/`

## Resources

### References

- Docker docs: https://docs.docker.com/
- Docker Compose docs: https://docs.docker.com/compose/
- NGINX docs: https://nginx.org/en/docs/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
- WordPress docs: https://developer.wordpress.org/

### AI usage

AI assistance was used for:

- Reviewing container healthcheck behavior and startup flow
- Drafting and refining documentation structure and wording
- Cross-checking NGINX proxy patterns and Docker Compose service wiring

## Project Description

### Architecture and design choices

- One Dockerfile per service (NGINX, WordPress, MariaDB, and bonus front-page)
- NGINX is the only external entrypoint on port 443
- Inter-service communication happens only inside a dedicated bridge network
- Data persistence uses Docker named volumes configured to store host data under `/home/ihadj/data`
- Service startup ordering uses healthchecks and `depends_on` conditions

### Virtual Machines vs Docker

- Virtual Machines emulate full operating systems with their own kernels and are heavier.
- Docker containers share the host kernel, start faster, and consume fewer resources.
- For this project, Docker is preferred for reproducible multi-service deployment and quick rebuild cycles.

### Secrets vs Environment Variables

- Environment variables are easy to inject but can leak through logs or process inspection if mishandled.
- Secrets are safer for sensitive values because they are managed as files with tighter scope and lifecycle.
- This project uses environment variables for configuration and a local secrets directory for secure workflow organization.

### Docker Network vs Host Network

- Bridge network isolates containers while allowing explicit service-to-service communication.
- Host network removes isolation and can cause port conflicts and weaker boundaries.
- This stack uses a dedicated bridge network to keep services isolated and predictable.

### Docker Volumes vs Bind Mounts

- Volumes are Docker-managed and portable across environments.
- Bind mounts directly expose host paths and are more tightly coupled to host layout and permissions.
- Here, persistent data is handled with named volumes mapped to `/home/ihadj/data` per project requirements.