locals {
  node_group_name = "lab-shared"
  instance_types  = ["t3.medium"]
}

resource "aws_eks_node_group" "lab_shared_node_group" {
  cluster_name    = data.terraform_remote_state.eks.outputs.cluster_name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.lab_shared_node_group_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets
  instance_types = local.instance_types

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
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