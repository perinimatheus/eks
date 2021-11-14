terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-nginx-ingress"
    region = "us-east-1"
  }
}
