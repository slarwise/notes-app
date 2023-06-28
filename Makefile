.PHONY: start-database
start-database:
	docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

.PHONY: stop-database
stop-database:
	docker kill redis-stack-server
	docker rm redis-stack-server

.PHONY: start-api
start-api:
	env OTEL_TRACES_EXPORTER=otlp  \
		OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://localhost:4318/v1/traces \
		OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://localhost:9090/v1/metrics \
		OTEL_SERVICE_NAME=notes \
		node --require @opentelemetry/auto-instrumentations-node/register app.js

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

.PHONY: jaeger
jaeger:
	docker run -d --name jaeger \
		-e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
		-e COLLECTOR_OTLP_ENABLED=true \
		-p 6831:6831/udp \
		-p 6832:6832/udp \
		-p 5778:5778 \
		-p 16686:16686 \
		-p 4317:4317 \
		-p 4318:4318 \
		-p 14250:14250 \
		-p 14268:14268 \
		-p 14269:14269 \
		-p 9411:9411 \
		jaegertracing/all-in-one:latest

.PHONY: stop-jaeger
stop-jaeger:
	docker kill jaeger
	docker rm jaeger

.PHONY: prometheus
prometheus:
	docker run -d --name prometheus -p 9090:9090 prom/prometheus

.PHONY: stop-prometheus
stop-prometheus:
	docker kill prometheus
	docker rm prometheus
