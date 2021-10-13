#############################
# VARIAVEIS OBRIGATORIAS
#############################
variable "cluster_name" {
  type = string
}

variable "ng_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "cluster_ca" {
  type = string
}

variable "subnet_ids" {
  type = list
}

variable "eks_cluster_sg_id" {
  type = string
}

###############################
# VARIAVEIS NÃO OBRIGATORIAS
###############################

variable "desired_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 1
}

variable "instance_types" {
  default = [
    "t3.medium"
  ]
  type = list
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "image_id" {
  type = string
  default = ""
}

variable "security_groups" {
  type = list
  default = []
}

variable "k8s_labels" {
  type = map
  default = {}
}