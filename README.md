# Notes app

A project to practice using microservice patterns

## Goals

Include the following:

- At least 2 services
- Aggregated logging
- Distributed tracing
- Metrics
- Grafana
- Github actions

## Architecture

- Frontend
- Backend
- Database

## Features

Write a note and give it a title/key. Be able to fetch all notes or a specific
note by giving the key. Optional: Filter notes by metadata or by text.

## Running

To start everything, do

```sh
make start-database
make jaeger
make prometheus
make start-api

# Create and get some notes
make create-notes
make get-notes
make get-note

# Traces are displayed at http://localhost:16686
# Metrics are displayed at http://localhost:9090/metrics

# To stop all docker containers
make stop-database
make stop-jaeger
make stop-prometheus
```
