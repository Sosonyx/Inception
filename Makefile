COMPOSE_FILE = srcs/docker-compose.yml

all: setup build up

setup:
	@mkdir -p /home/ihadj/data/mariadb
	@mkdir -p /home/ihadj/data/wordpress

build:
	@docker compose -f $(COMPOSE_FILE) build

up:
	@docker compose -f $(COMPOSE_FILE) up -d

down:
	@docker compose -f $(COMPOSE_FILE) down

clean: down
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker volume rm srcs_mariadb_data 2>/dev/null || true
	@docker volume rm srcs_wordpress_html 2>/dev/null || true
	@docker image prune -a -f

re: fclean all

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

status:
	@docker compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re logs status