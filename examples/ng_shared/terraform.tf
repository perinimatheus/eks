terraform {
  backend "s3" {
    bucket = "tfstate-perini"
    key    = "lab-node-groups-shared"
    region = "us-east-1"
  }
}
