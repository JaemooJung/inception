NAME = inception

UNAME	:= $(shell uname -s)
IS_HOST_SET := $$(cat /etc/hosts | grep "jaemjung.42.fr" | wc -l)

ifeq ($(UNAME),Darwin)	#macOS
	DB_PATH		:= /Users/jaemoojung/Desktop/42/42SEOUL/circle_5/inception/data
else					#Linux
	DB_PATH		:= /home/jaemjung/data
endif

.PHONY : all clean fclean re

all: $(NAME)

$(NAME):
	mkdir -p $(DB_PATH)/mariadb/
	mkdir -p $(DB_PATH)/wordpress/
	@if [ $(IS_HOST_SET) -eq 0 ]; then \
		echo "setting up host domain"; \
		echo "127.0.0.1 jaemjung.42.fr" | sudo tee -a /etc/hosts; \
	fi
	docker-compose -f ./srcs/docker-compose.yml up --build -d 

start:
	docker-compose -f ./srcs/docker-compose.yml start

stop:
	docker-compose -f ./srcs/docker-compose.yml stop

restart:
	docker-compose -f ./srcs/docker-compose.yml restart

clean:
	docker-compose -f ./srcs/docker-compose.yml down --rmi "all" --volumes

fclean: clean
	rm -rf $(DB_PATH)

re: fclean all