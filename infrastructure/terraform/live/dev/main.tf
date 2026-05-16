provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../../modules/vpc"

  name                = "three-tier-${var.environment}"
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  enable_nat_gateway  = true
  single_nat_gateway  = true   # for cost savings in dev
}

module "eks" {
  source = "../../modules/eks"

  cluster_name          = "three-tier-${var.environment}"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  cluster_version       = var.cluster_version
  node_group_desired_size = var.node_group_desired_size
  node_group_max_size   = var.node_group_max_size
  node_group_min_size   = var.node_group_min_size
  node_instance_types   = var.node_instance_types
  tags                  = var.tags
}

module "ecr" {
  source = "../../modules/ecr"

  repository_names = ["frontend", "backend"]
  tags             = var.tags
}