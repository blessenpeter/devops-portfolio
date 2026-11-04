# VPC module

Reusable Terraform module that builds a basic AWS network: one VPC with a public and a private subnet in a single Availability Zone.

## What it creates

| Resource | Purpose |
|---|---|
| `aws_vpc.main` | The VPC |
| `aws_subnet.public_a` / `aws_subnet.private_a` | One public and one private subnet |
| `aws_internet_gateway.igw` | Internet access for the public subnet |
| `aws_route_table.public` + `aws_route.public_internet` | Public route table with `0.0.0.0/0` to the internet gateway |
| `aws_route_table.private` | Private route table (no internet route) |
| `aws_route_table_association.*` | Links each subnet to its route table |

## Inputs

| Name | Description | Required | Example |
|---|---|---|---|
| `project` | Name prefix for every resource | yes | `tf` |
| `az` | Availability Zone for both subnets | yes | `eu-west-2a` |
| `vpc_cidr` | CIDR block for the VPC | yes | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR block for the public subnet | yes | `10.0.1.0/24` |
| `private_subnet_cidr` | CIDR block for the private subnet | yes | `10.0.2.0/24` |

All inputs are required (no defaults), so each root module chooses its own values.

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the VPC |
| `public_subnet_id` | ID of the public subnet |
| `private_subnet_id` | ID of the private subnet |
| `vpc_cidr` | CIDR block of the VPC |

## Usage

```hcl
module "vpc" {
  source = "../modules/vpc"

  project             = "demo"
  az                  = "eu-west-2a"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}
```

Read results with `module.vpc.vpc_id`, `module.vpc.public_subnet_id` and so on.

## Notes

- No provider or backend block: the calling (root) module configures the AWS provider and stores the state.
- Single Availability Zone and no NAT gateway, so private subnets have no internet access. Kept free to run.
