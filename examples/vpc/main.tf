locals {
  cluster_name = "lab"
}
module "vpc" {
  source       = "../../modules/vpc"
  cluster_name = local.cluster_name
  aws_region   = "us-east-1"
  azs          = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr     = "10.0.0.0/16"
  public_cidr  = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  private_cidr = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
  #secondary_cidr = "11.0.0.0/16"
  #pods_cidr      = ["11.0.0.0/19", "11.0.32.0/19", "11.0.64.0/19"]
}
