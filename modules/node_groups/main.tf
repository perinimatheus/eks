terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-node-groups-shared"
    region = "us-east-1"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = data.aws_eks_cluster_auth.default.token
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

data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
}