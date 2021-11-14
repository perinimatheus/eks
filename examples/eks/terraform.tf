terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-eks"
    region = "us-east-1"
  }
}
