# postgres-volume

Shows how a named Docker volume keeps PostgreSQL data safe when the container is replaced.

## Steps
1. `docker volume create pgdemo`
2. `docker run -d --name pg3 -e POSTGRES_PASSWORD=<your-password> -v pgdemo:/var/lib/postgresql postgres:18`
3. Add a row: `docker exec -it pg3 psql -U postgres`, then
   `CREATE TABLE notes (msg text);` and `INSERT INTO notes VALUES ('replay test');`
4. Replace the container: `docker stop pg3` then `docker rm pg3`
5. `docker run -d --name pg4 ... -v pgdemo:/var/lib/postgresql postgres:18`
6. `SELECT * FROM notes;` in pg4 still returns `replay test`

## Notes
- PostgreSQL 18+ keeps data under `/var/lib/postgresql` (17 and older: `/var/lib/postgresql/data`).
- Always check the mount: `docker inspect --format '{{json .Mounts}}' <container>`.
  A one-character typo in the mount path left the data in an unnamed volume;
  `docker inspect` showed the problem before any data was at risk.
- Databases are stopped gracefully (`docker stop`) before removal.
