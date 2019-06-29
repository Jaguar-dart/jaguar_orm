# Postgresql server based on Docker

This folder contains files to fire up a docker based postgres server for testing various Jaguar's postgres solutions.

# Usage

To fire up the postgresql server, make sure you have `docker` installed. Type:

```bash
docker-compose up
```

postgresql server should be up now.

# Connecting to the database

```
psql postgresql://postgres:dart_jaguar@localhost:5432/postgres
```
