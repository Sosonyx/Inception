COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

all: build up

build:
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@docker-compose -f $(COMPOSE_FILE) down

clean: down
	@docker-compose -f $(COMPOSE_FILE) down -v
	@docker system prune -af

fclean: clean
	@sudo rm -rf $(DATA_DIR)/wordpress
	@sudo rm -rf $(DATA_DIR)/mariadb

re: fclean all

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

status:
	@docker-compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re logs status