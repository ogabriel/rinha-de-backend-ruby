USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)
PROJECT=$(shell basename $(PWD))

dev:
	USER_ID=$(USER_ID) GROUP_ID=$(GROUP_ID) docker compose -f docker-compose.dev.yml -p $(PROJECT)-dev up

dev-build:
	USER_ID=$(USER_ID) GROUP_ID=$(GROUP_ID) docker compose -f docker-compose.dev.yml -p $(PROJECT)-dev up --build

dev-exec:
	docker compose -p $(PROJECT)-dev exec app sh

dev-local:
	build_postgres-15 || exit 0
	./bin/rails server

database-check:
	until nc -z -v -w30 localhost 5432; do \
	  sleep 1; \
	done

docker-compose-one:
	make docker-compose-down
	docker compose -f docker-compose.one.yml -p $(PROJECT)-one up

docker-compose-one-build:
	make docker-compose-down
	docker compose -f docker-compose.one.yml -p $(PROJECT)-one up --build

docker-compose-two:
	make docker-compose-down
	docker compose -f docker-compose.two.yml -p $(PROJECT)-two up

docker-compose-two-build:
	make docker-compose-down
	docker compose -f docker-compose.two.yml -p $(PROJECT)-two up --build

docker-compose-down:
	docker stop postgres-15 || exit 0
	docker stop postgres-11 || exit 0
	docker stop postgres || exit 0
	docker compose -p $(PROJECT)-dev down || exit 0
	docker compose -p $(PROJECT)-two down || exit 0
	docker compose -p $(PROJECT)-one down || exit 0
