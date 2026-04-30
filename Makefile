DOCKER := /usr/bin/docker
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = $(DOCKER) compose -f $(COMPOSE_FILE)

all: setup build up

setup:
	@mkdir -p /home/ihadj/data/mariadb
	@mkdir -p /home/ihadj/data/wordpress

build:
	@$(COMPOSE) build

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

clean: down
	@$(COMPOSE) down -v

fclean: clean
	@$(DOCKER) volume rm srcs_mariadb_data 2>/dev/null || true
	@$(DOCKER) volume rm srcs_wordpress_html 2>/dev/null || true
	@$(DOCKER) image prune -a -f

re: fclean all

logs:
	@$(COMPOSE) logs -f

status:
	@$(COMPOSE) ps

.PHONY: all build up down clean fclean re logs status