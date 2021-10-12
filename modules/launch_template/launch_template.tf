locals {

}


data "cloudinit_config" "workers_userdata" {
  gzip          = false
  base64_encode = true
  boundary      = "//"

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/userdata.sh.tpl",
      {
        kubelet_extra_args   = var.kubelet_extra_args
        pre_userdata         = var.pre_userdata
        ami_id               = var.image_id != "" ? var.image_id : ""
        ami_is_eks_optimized = true
        cluster_name         = var.cluster_name
        cluster_endpoint     = var.eks_cluster_endpoint
        cluster_ca           = var.cluster_ca
        capacity_type        = var.capacity_type
        append_labels        = length(var.k8s_labels) > 0 ? ",${join(",", [for k, v in var.k8s_labels : "${k}=${v}"])}" : ""
      }
    )
  }
}

resource "aws_launch_template" "cluster_launch_template" {
  name                   = "${var.worker_group_name}-worker-group-lt"
  description            = "EKS Node Group custom LT for ${var.worker_group_name}"
  update_default_version = var.update_default_version

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }

  ebs_optimized = var.ebs_optimized

  #instance_type = var.instance_type

  monitoring {
    enabled = var.monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
  }

  #image_id = var.image_id

  user_data = data.cloudinit_config.workers_userdata.rendered

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = null
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.worker_group_name
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = var.worker_group_name
    }
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = {
      Name = var.worker_group_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

