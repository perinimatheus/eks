#############################
# VARIAVEIS OBRIGATORIAS
#############################

variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

###############################
# VARIAVEIS NÃO OBRIGATORIAS
###############################

variable "public_access_cidrs" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}
