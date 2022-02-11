terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-prometheus-operator"
    region = "us-east-1"
  }
}
