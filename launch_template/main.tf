terraform {
  required_providers{
      aws = {
        source  = "hashicorp/aws"
        version = "~> 3.27"
      }
  }

  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-launch-template"
    region = "us-east-1"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}
