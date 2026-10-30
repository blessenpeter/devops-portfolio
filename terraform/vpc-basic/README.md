# Terraform: AWS VPC (public + private subnet)

Rebuilds, in Terraform, a VPC I first built by hand in the AWS console.

## What it creates (eu-west-2)
| Resource | Name (default `project = "tf"`) | Detail |
|---|---|---|
| VPC | tf-vpc | 10.0.0.0/16 |
| Subnet | tf-public-a | 10.0.1.0/24, eu-west-2a |
| Subnet | tf-private-a | 10.0.2.0/24, eu-west-2a |
| Internet gateway | tf-igw | attached to the VPC |
| Route table | tf-public-rt | local + 0.0.0.0/0 → IGW, associated with tf-public-a |
| Route table | tf-private-rt | local only, associated with tf-private-a |

9 resources in total (including the route and the two associations).

## Files
| File | Contains |
|---|---|
| `providers.tf` | Terraform and AWS provider versions, region, CLI profile |
| `variables.tf` | Inputs with defaults: region, project prefix, AZ, CIDR blocks |
| `main.tf` | The 9 resources, built only from variables and references |
| `outputs.tf` | VPC ID, subnet IDs and VPC CIDR, handed back after apply |

## What I practised
- **Dependency graph:** no order is written anywhere; Terraform works it out from references (`aws_vpc.main.id`). Apply created the VPC first, then subnets, IGW and route tables in parallel, then the route and associations. Destroy ran in reverse.
- **Variables:** one codebase, different values. `terraform plan -var="project=dev"` renamed every resource to `dev-*` with no code changes.
- **Outputs:** IDs AWS assigns at apply time are returned by name. A script used one directly: `aws ec2 describe-vpcs --vpc-ids $(terraform output -raw vpc_id)`.
- **Saved plans:** `terraform plan -out=tfplan` then `terraform apply tfplan` applies exactly the reviewed plan; applying it a second time fails with "Saved plan is stale".
- **State:** inspected with `terraform state show`; `serial` increases on every write, `lineage` stays the same; outputs and all attributes (including sensitive values) live in state.
- **Drift:** changed a subnet's Name tag in the console; `plan` showed `~ update in-place` back to the value in code, and `apply` corrected it.
- **Safe setup:** dedicated least-privilege IAM user (`AmazonVPCFullAccess`) via a named CLI profile; no keys in code. State files, plan files and `.terraform/` are git-ignored; the lock file is committed.

## Run it
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform output
terraform destroy   # always destroy after the lab
```

## Remote state

State is stored in S3 (bucket created by `terraform/state-bootstrap`), key `vpc-basic/terraform.tfstate`, with encryption and S3 native locking (`use_lockfile`). See `backend.tf`. Migrated from local state with `terraform init -migrate-state`; `terraform plan` afterwards reported no changes.

## Next

Turn this VPC into a reusable module.
