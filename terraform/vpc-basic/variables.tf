variable "region" {
  description = "AWS region to build in"
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Name prefix for every resource"
  type        = string
  default     = "tf"
}

variable "az" {
  description = "Availability zone for both subnets"
  type        = string
  default     = "eu-west-2a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}