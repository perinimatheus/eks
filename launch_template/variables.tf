
variable "worker_group_name" {
  type = string
  default = "lab"
}
variable "volume_type" {
  type = string
  default = "gp2"
}

variable "security_groups" {
  type = list
  default = []
}

variable "volume_size" {
  type = number
  default = 20
}

variable "monitoring" {
  type = bool
  default = true
}

variable "image_id" {
  type = string
  default = "ami-0800826177b25080e"
}

variable "cpu_credits" {
  type = string
  default = "standard"
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}

variable "ebs_optimized" {
  type = bool
  default = false
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "update_default_version" {
  type = bool
  default = true
}