# VPC with a web server (Terraform)

Builds a small AWS network and a public web server with Terraform, then serves a page over HTTP.

## What it creates (13 resources)
- VPC with one public and one private subnet, an internet gateway, route tables and associations
- Security group with separate rule resources: inbound HTTP (80) from anywhere, all outbound
- EC2 instance (`t3.micro`) in the public subnet with a public IP, running nginx installed by `user_data`

## Design notes
- **AMI lookup:** a data source finds the newest Amazon Linux 2023 image published by Amazon, so no AMI ID is hard-coded.
- **Explicit egress:** Terraform removes AWS's default allow-all egress rule, so outbound access is declared in code.
- **No SSH:** the server is tested over HTTP only, which keeps the attack surface small.
- **`user_data_replace_on_change`:** changing the boot script replaces the instance, so the new script actually runs.
- **`depends_on`:** the instance waits for the internet route and the egress rule, so the boot-time install never races them.

## Usage
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
curl -i $(terraform output -raw web_url)
terraform destroy
```

## Files
| File | Contents |
|---|---|
| `providers.tf` | AWS provider and region |
| `variables.tf` | Inputs (project name, region, CIDRs, AZ) |
| `main.tf` | VPC, subnets, internet gateway, routing |
| `security.tf` | Security group and its rules |
| `compute.tf` | AMI lookup and the EC2 instance |
| `outputs.tf` | IDs, AMI details and the web URL |