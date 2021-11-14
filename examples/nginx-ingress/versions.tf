terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.11"
}
