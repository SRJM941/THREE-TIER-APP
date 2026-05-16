variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

# Cost Optimization: Desired size 1 kar rahe hain taaki instant apply ho bina standard lock ke
variable "node_group_desired_size" {
     type = number 
     default = 1 
}
variable "node_group_max_size"    { 
    type = number 
    default = 1 
}

variable "node_group_min_size"    {
     type = number 
     default = 1 
}

# Instance type ko t3.small kar rahe hain jo credit friendly hai aur EKS resources handle kar lega
variable "node_instance_types"    {
     type = list(string) 
     default = ["t3.small"] 
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "three-tier-app"
    ManagedBy   = "Terraform"
  }
}