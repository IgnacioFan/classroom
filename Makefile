-include .env
export

app.build:
	docker-compose up --build

app.start:
	docker-compose up

app.stop:
	docker-compose down

console:
	docker exec -it $(APP_NAME) rails console

db.setup:
	docker exec -it $(APP_NAME) rails db:create && docker exec -it $(APP_NAME) rails db:migrate

db.cli:
	docker exec -it $(POSTGRES_HOST) psql -U $(POSTGRES_USER)
