data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tfstate-perini"
    key    = "lab-eks"
    region = "us-east-1"
  }
}
