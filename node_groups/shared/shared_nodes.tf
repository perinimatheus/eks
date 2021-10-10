locals {
  node_group_name = "${var.cluster_name}-shared"
}

module "launh_template" {
  source = "../../launch_template"

  
}

resource "aws_eks_node_group" "lab_shared_node_group" {
  cluster_name    = data.terraform_remote_state.eks.outputs.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.lab_shared_node_group_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets
  instance_types  = var.instance_types
  capacity_type   = "SPOT"

  labels = {
    product = "shared"
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "Terraform"                                                                         = "true"
    "Node_group"                                                                        = "shared"
    "environment"                                                                       = "lab"
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.eks.outputs.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                                                 = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.lab_shared_node_group_nodeAmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.lab_shared_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.lab_shared_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "lab_shared_node_group_role" {
  name = "eks-node-group-${local.node_group_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "lab_shared_node_group_nodeAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.lab_shared_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "lab_shared_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.lab_shared_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "lab_shared_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.lab_shared_node_group_role.name
}

resource "aws_security_group" "lab_shared_cluster_nodes_sg" {
    name = "${local.node_group_name}-nodes-sg"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${local.node_group_name}-nodes-sg"
    }

}