terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-external-dns"
    region = "us-east-1"
  }
}
