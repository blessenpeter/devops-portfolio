terraform {
  backend "s3" {
    bucket       = "blessen-tfstate-lab-3010"
    key          = "vpc-basic/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
