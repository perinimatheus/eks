terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-cluster-autoscaler"
    region = "us-east-1"
  }
}
