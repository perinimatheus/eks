#############################
# VARIAVEIS OBRIGATORIAS
#############################

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}