data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-perini"
    key    = "lab-vpc"
    region = "us-east-1"
  }
}
