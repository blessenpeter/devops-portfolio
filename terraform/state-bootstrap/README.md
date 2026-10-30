# Terraform remote state: S3 bootstrap

Creates the S3 bucket that stores Terraform state for the other projects in this portfolio, and shows how an existing project moves from local to remote state.

## Why remote state

Local state (a file on one laptop) has four problems: no sharing, no locking, a single point of failure, and secrets in plain text on laptops. An S3 backend gives one shared, versioned, encrypted state with native locking.

## The chicken-and-egg problem

The backend is set up during `terraform init`, before any resources exist, and a backend block cannot reference resources or variables. So the state bucket is created first by this small bootstrap project, which keeps its own state locally.

## What it creates

| Resource | Purpose |
|---|---|
| `aws_s3_bucket` | The state bucket (`prevent_destroy` stops accidental deletion) |
| `aws_s3_bucket_versioning` | Keeps previous state versions for rollback |
| `aws_s3_bucket_server_side_encryption_configuration` | Encryption at rest (SSE-S3, AES256) |
| `aws_s3_bucket_public_access_block` | Blocks all public access |

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # set a globally unique bucket name
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Using the bucket from another project

Add a `backend.tf` (example from `terraform/vpc-basic`):

```hcl
terraform {
  backend "s3" {
    bucket       = "blessen-tfstate-lab-3010"
    key          = "vpc-basic/terraform.tfstate"
    region       = "eu-west-2"
    profile      = "terraform-lab"
    encrypt      = true
    use_lockfile = true
  }
}
```

Then run `terraform init -migrate-state` and answer `yes` to copy the existing local state. Each project uses its own `key`.

## What I verified

- **Versioning:** `aws s3api get-bucket-versioning` returned `"Status": "Enabled"`.
- **Migration:** the local state (9 resources) was copied to `vpc-basic/terraform.tfstate`, and `terraform plan` then reported **No changes**.
- **Locking:** while a `destroy` waited for approval, a second `terraform plan` failed with `Error acquiring the state lock` (S3 conditional write returned 412). The `.tflock` object disappeared when the run finished.
- **Rollback:** `aws s3api list-object-versions` showed the previous state versions still stored.

## Design notes

- Locking uses S3 native lock files (`use_lockfile = true`). DynamoDB-based locking is deprecated.
- The bootstrap project's own state stays local and git-ignored. If it were lost, the bucket could be re-imported.
- Lab permissions use AWS managed policies. In production I would use one least-privilege policy limited to the state bucket, the state keys and their `.tflock` files.
- Tear-down: remove `prevent_destroy`, empty every object version, then destroy.

## Files

| File | Purpose |
|---|---|
| `providers.tf` | Terraform and AWS provider versions, region, profile |
| `variables.tf` | `region` (default `eu-west-2`) and `state_bucket_name` (required) |
| `terraform.tfvars.example` | Placeholder values (copy to `terraform.tfvars`, which is git-ignored) |
| `main.tf` | The bucket and its three settings resources |
| `outputs.tf` | Bucket name and ARN |
