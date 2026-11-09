# The whole VPC now comes from the reusable module
module "vpc" {
  source = "../modules/vpc"

  project=var.project
  az                  = var.az
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}
