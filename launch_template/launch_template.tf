locals {

}

resource "aws_launch_template" "cluster_launch_template" {
  name = "${var.worker_group_name}-worker-group-lt"
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

  instance_type = var.instance_type

  monitoring {
    enabled = var.monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = var.security_groups
  }

  image_id = var.image_id

  #user_data = filebase64("${path.module}/example.sh")

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

