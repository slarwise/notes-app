.PHONY: start-database
start-database:
	docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

.PHONY: stop-database
stop-database:
	docker kill redis-stack-server
	docker rm redis-stack-server

.PHONY: start-api
start-api:
	node app.js

.PHONY: create-notes
create-notes:
	curl http://localhost:3000/notes -d '{"title": "my-journey", "text": "This is it."}' -H "Content-Type: application/json"
	curl http://localhost:3000/notes -d '{"title": "today", "text": "Today I ate some food."}' -H "Content-Type: application/json"
	curl http://localhost:3000/notes -d '{"title": "concert", "text": "Listened to some music, epic."}' -H "Content-Type: application/json"

.PHONY: list-notes
list-notes:
	curl 'http://localhost:3000/notes' | jq

.PHONY: get-note
get-note:
	curl 'http://localhost:3000/notes/concert' | jq
