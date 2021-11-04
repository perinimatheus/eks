locals {
  cluster_name = "lab"
}
module "vpc" {
  source = "../../modules/vpc"
  cluster_name = local.cluster_name
  enable_secondary_cidr = false
}
