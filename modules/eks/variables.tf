#############################
# VARIAVEIS OBRIGATORIAS
#############################

variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "vpc_id" {
  type = string
}

###############################
# VARIAVEIS NÃO OBRIGATORIAS
###############################

variable "public_access_cidrs" {
  type = list
  default = ["0.0.0.0/0"]
}

