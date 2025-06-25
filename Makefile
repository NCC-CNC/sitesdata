## Launch local version for development ----
demo:
	docker-compose --env-file .env.local  up --build

demo-kill:
	docker-compose --env-file .env.local down
	
get-in-to-test:
	docker exec -it sitesdata-backend-pipeline-1 bash

debug-pipeline:
	R && \
	source("R/__pipeline__.R", echo = TRUE, verbose = TRUE)