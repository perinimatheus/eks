terraform {
  required_providers{
      aws = {
        source  = "hashicorp/aws"
        version = "~> 3.27"
      }
  }

  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-node-groups"
    region = "us-east-1"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
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