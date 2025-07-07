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
	
named-volume:
	docker volume create sitesdata-transactional_db 
	
get-shiny-id:
	docker run --rm f3722be50fe9 id shiny