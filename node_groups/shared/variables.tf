variable "cluster_name" {
  default = "lab"
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}

variable "instance_types" {
  default = [
      "t3.medium"
    ]
  type = list
}