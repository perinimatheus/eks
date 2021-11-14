terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-vpc"
    region = "us-east-1"
  }
}
