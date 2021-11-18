data "aws_eks_cluster_auth" "cluster_ca_token" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tfstate-perini"
    key    = "lab-eks"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-perini"
    key    = "lab-vpc"
    region = "us-east-1"
  }
}
