locals {
  cluster_name = "lab"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["11.0.0.0/20", "11.0.16.0/20", "11.0.32.0/20"]
  public_subnets  = ["11.0.112.0/20", "11.0.128.0/20", "11.0.144.0/20"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = {
    Terraform = "true"
    Environment = "lab"
  }
}