# Compose: PostgreSQL + Adminer

A two-service Docker Compose app: a PostgreSQL 18 database and Adminer, a web UI for it.

## What it shows
- **Two services on one network:** Compose creates a network automatically; Adminer reaches the database by its **service name** `db`.
- **Only the web UI is published:** Adminer has `8082:8080`; the database has **no published port** and is reachable only inside the Compose network.
- **Persistent data:** a named volume `pgdata` at `/var/lib/postgresql` keeps data across `docker compose down` / `up`; `down -v` deletes it.
- **No secrets in Git:** the password comes from a `.env` file (`${POSTGRES_PASSWORD}`), which `.gitignore` excludes; `.env.example` is the template.

## Run it
```
cp .env.example .env        # then set your own password in .env
docker compose up -d
```
Open http://localhost:8082 and log in: System **PostgreSQL**, Server **db**, Username **postgres**, Password **<your-password>**.

## Check and clean up
```
docker compose ps
docker compose exec db psql -U postgres -c "SELECT version();"
docker compose down        # keeps the data volume
docker compose down -v     # also deletes the data volume
```