#############################
# VARIAVEIS OBRIGATORIAS
#############################
variable "cluster_name" {
  type = string
}

variable "k8s_labels" {
  type = map
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

variable "kubelet_extra_args" {
  type = string
  default = ""
}

variable "pre_userdata" {
  type    = string
  default = ""
}

variable "update_default_version" {
  type    = bool
  default = true
}

variable "ebs_optimized" {
  type    = bool
  default = false
}

variable "cpu_credits" {
  type    = string
  default = "standard"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "monitoring" {
  type    = bool
  default = true
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "volume_device_name" {
  type  = string
  default  = "/dev/xvda"
}