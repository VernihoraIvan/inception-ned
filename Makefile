COMPOSE_FILE=./srcs/docker-compose.yml
DATA_PATH=/home/$(USER)/data

all: up

up:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	docker compose -f $(COMPOSE_FILE) up -d

build:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	docker compose -f $(COMPOSE_FILE) build

down:
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

clean: down
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

fclean: clean
	sudo rm -rf $(DATA_PATH)/wordpress/*
	sudo rm -rf $(DATA_PATH)/mariadb/*

re: fclean all

.PHONY: all up build down clean fclean re logs ps
