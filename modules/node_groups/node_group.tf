locals {
  node_group_name = "${var.cluster_name}-${var.ng_name}"
}

module "launch_template" {
  source = "../launch_template"

  worker_group_name           = local.node_group_name
  security_groups             = [ 
    "${join(",", [for s in var.security_groups : "${s}"])}",
    "${aws_security_group.eks_shared_cluster_nodes_sg.id}"
    ]
  associate_public_ip_address = var.associate_public_ip_address
  k8s_labels                  = var.k8s_labels
  capacity_type               = var.capacity_type
  cluster_name                = var.cluster_name
  eks_cluster_endpoint        = var.eks_cluster_endpoint
  cluster_ca                  = var.cluster_ca
  image_id                    = var.image_id
  kubelet_extra_args          = var.kubelet_extra_args

}

resource "aws_eks_node_group" "eks_shared_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.eks_shared_node_group_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type

  launch_template {
    id      = module.launch_template.launch_template_id
    version = module.launch_template.launch_template_latest_version
  }

  labels = var.k8s_labels

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
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                                                 = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_shared_node_group_nodeAmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_shared_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_shared_node_group_AmazonEC2ContainerRegistryReadOnly,
    module.launch_template
  ]
}

resource "aws_iam_role" "eks_shared_node_group_role" {
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

resource "aws_iam_role_policy_attachment" "eks_shared_node_group_nodeAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_shared_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_shared_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_shared_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_shared_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_shared_node_group_role.name
}

resource "aws_security_group" "eks_shared_cluster_nodes_sg" {
  name   = "${local.node_group_name}-nodes-sg"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.node_group_name}-nodes-sg"
  }

}

resource "aws_security_group_rule" "nodes_ingress_https" {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"

    source_security_group_id = var.eks_cluster_sg_id
    security_group_id = aws_security_group.eks_shared_cluster_nodes_sg.id
    type = "ingress"
}

resource "aws_security_group_rule" "nodes_ingress_node_port" {
    from_port   = 30000
    to_port     = 32768
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

    security_group_id = aws_security_group.eks_shared_cluster_nodes_sg.id
    type = "ingress"
}

resource "kubernetes_config_map" "aws-auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${aws_iam_role.eks_shared_node_group_role.arn}
  username: system:node:{{EC2PrivateDNSName}}  
  groups:
    - system:bootstrappers
    - system:nodes
    - system:nodes-proxier
YAML
  }
}