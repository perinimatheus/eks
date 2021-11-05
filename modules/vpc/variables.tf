#############################
# VARIAVEIS OBRIGATORIAS
#############################

variable "cluster_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_cidr" {
  type = list(string)
}

variable "public_cidr" {
  type = list(string)
}

variable "pods_cidr" {
  type = list(string)
  default = []
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "secondary_cidr" {
  type = string
  default = ""
}