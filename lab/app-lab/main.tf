terraform {
  required_providers{
      helm = {
        source  = "hashicorp/helm"
        version = "~> 2.3.0"
      }

      aws = {
        source  = "hashicorp/aws"
        version = "~> 3.27"
      }
  }

  backend "s3" {
    bucket = "tfstate-perini"
    key    = "app-lab"
    region = "us-east-1"
  }

  required_version = ">= 0.14.11"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region = "us-east-1"
}
