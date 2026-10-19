# DevOps portfolio

Hands-on projects covering containers, cloud and automation. Each folder has its own README with steps to run it.

## Projects
| Project | What it shows |
|---|---|
| [docker/my-web](docker/my-web) | Custom nginx image: Dockerfile, build and tag, port mapping, release and rollback |
| [docker/postgres-volume](docker/postgres-volume) | PostgreSQL on a named Docker volume: data survives container replacement; mount checked with docker inspect |
| [docker/compose-postgres-adminer](docker/compose-postgres-adminer) | Two-service Compose app: PostgreSQL 18 + Adminer; DB reached by service name, only the UI is published, named volume, password kept out of Git via `.env` |

## Coming next
- A Python Flask app in Docker
- AWS infrastructure with Terraform
- CI/CD with GitHub Actions
