variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "eu-west-2"
}

variable "state_bucket_name" {
  description = "Globally unique name for the Terraform state bucket"
  type        = string
}
