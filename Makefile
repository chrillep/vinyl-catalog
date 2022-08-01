help: ## Prints the help about targets.
	@printf "Usage:             ENV=[\033[34mprod|stage|dev\033[0m] make [\033[34mtarget\033[0m]\n"
	@printf "Default:           \033[34m%s\033[0m\n" $(.DEFAULT_GOAL)
	@printf "Targets:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[34m%-17s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

build-development: ## Build the development docker image.
	docker compose -f docker/development/docker-compose.yml build

start-development: ## Start the development docker container.
	docker compose -f docker/development/docker-compose.yml up -d

stop-development: ## Stop the development docker container.
	docker compose -f docker/development/docker-compose.yml down

build-staging: ## Build the staging docker image.
	docker compose -f docker/staging/docker-compose.yml build

start-staging: ## Start the staging docker container.
	docker compose -f docker/staging/docker-compose.yml up -d

stop-staging: ## Stop the staging docker container.
	docker compose -f docker/staging/docker-compose.yml down

build-production: ## Build the production docker image.
	docker compose -f docker/production/docker-compose.yml build

start-production: ## Start the production docker container.
	docker compose -f docker/production/docker-compose.yml up -d

stop-production: ## Stop the production docker container.
	docker compose -f docker/production/docker-compose.yml down

start-golang-server: ## Start Golang server
	cd services/api && \
	go run cmd/vinyl_catalog/main.go

start-nextjs-server: ## Start NextJS server
	npm --prefix clients/web run dev

start-servers: ## Start both server
	start-golang-server start-nextjs-server

build: ## Build image
	cd services/api && \
	docker build . -t rg.fr-par.scw.cloud/vinyl-catalog-registry/backend:latest

push: ## Push image
	cd services/api && \
	docker push  rg.fr-par.scw.cloud/vinyl-catalog-registry/backend:latest

build-and-push: build push