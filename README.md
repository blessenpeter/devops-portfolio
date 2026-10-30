# DevOps portfolio

Hands-on projects covering containers, cloud and automation. Each folder has its own README with steps to run it.

## Projects
| Project | What it shows |
|---|---|
| [docker/my-web](docker/my-web) | Custom nginx image: Dockerfile, build and tag, port mapping, release and rollback |
| [docker/postgres-volume](docker/postgres-volume) | PostgreSQL on a named Docker volume: data survives container replacement; mount checked with docker inspect |
| [docker/compose-postgres-adminer](docker/compose-postgres-adminer) | Two-service Compose app: PostgreSQL 18 + Adminer; DB reached by service name, only the UI is published, named volume, password kept out of Git via `.env` |
| [aws/s3-prefix-least-privilege](aws/s3-prefix-least-privilege) | IAM policy limiting S3 read access to one key prefix; bucket vs object ARNs; three IAM policy simulator tests (implicit deny vs explicit allow) |
| [terraform/vpc-basic](terraform/vpc-basic) | AWS VPC rebuilt in Terraform: public/private subnets, IGW, route tables (9 resources); dependency graph from references, plan/apply/destroy, drift detected and corrected; lock file committed; state migrated from local to the S3 remote backend |
| [terraform/vpc-web-server](terraform/vpc-web-server) | EC2 web server in Terraform: security group with separate ingress/egress rules (explicit egress), Amazon Linux 2023 AMI found by a data source, nginx installed by user_data, public URL as an output; saved plan applied, `depends_on` for a hidden dependency, tested with curl (HTTP 200), destroyed |
| [terraform/state-bootstrap](terraform/state-bootstrap) | Terraform remote state: bootstrap project creates a versioned, encrypted, private S3 state bucket (`prevent_destroy`); vpc-basic migrated with `init -migrate-state` (plan: no changes); S3 native locking shown blocking a second run; old state versions listed for rollback |

## Coming next
- A reusable Terraform module
- CI/CD with GitHub Actions
- A Python Flask app in Docker
