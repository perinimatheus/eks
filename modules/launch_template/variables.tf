
variable "worker_group_name" {
  type    = string
  default = "lab-node-group"
}
variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "security_groups" {
  type    = list
  default = []
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "monitoring" {
  type    = bool
  default = true
}

variable "image_id" {
  type = string
}

variable "cpu_credits" {
  type    = string
  default = "standard"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "ebs_optimized" {
  type    = bool
  default = false
}

variable "k8s_labels" {
  type = map
}

#variable "instance_type" {
#  type = string
#  default = "t3.medium"
#}

variable "update_default_version" {
  type    = bool
  default = true
}

variable "kubelet_extra_args" {
  type    = string
  default = ""
}

variable "pre_userdata" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "cluster_ca" {
  type = string
}

variable "capacity_type" {
  type = string
}