COMPOSE=@docker compose -f ./srcs/docker-compose.yml

up:
	sudo mkdir -p /Users/ivanvernihora/Documents/GitHub/data/wordpress
	sudo mkdir -p /Users/ivanvernihora/Documents/GitHub/data/mariadb
	sudo mkdir -p /Users/ivanvernihora/Documents/GitHub/data/website
	sudo chown -R 33:33 /Users/ivanvernihora/Documents/GitHub/data/wordpress
	$(COMPOSE) up -d

re:
	$(COMPOSE) build --no-cache
		$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

remaria: stop
	sudo rm -rf /home/iverniho/data/mariadb
	$(COMPOSE) build --no-cache mariadb


# rewp: stop
# 	sudo rm -rf /home/iverniho/data/wordpress
# 	$(COMPOSE) build --no-cache wordpress

# renginx: stop
# 	sudo rm -rf /home/iverniho/data/nginx
# 	$(COMPOSE) build --no-cache nginx

inside_wp:
	docker exec -it wordpress bash

inside_mariadb:
	docker exec -it mariadb bash

inside_nginx:
	docker exec -it nginx bash

connect_ftp:
	ftp 127.0.0.1

all: up
