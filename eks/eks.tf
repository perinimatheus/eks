locals {
  cluster_name = "lab"
}

resource "aws_eks_cluster" "lab_cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.lab_cluster_role.arn

  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  }

  tags = {
    "environment" = var.environment
    "Terraform" = "true"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.lab_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.lab_AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.lab_cluster_log_group
  ]
}

resource "aws_iam_role" "lab_cluster_role" {
  name = "eks-cluster-${local.cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lab_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.lab_cluster_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "lab_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.lab_cluster_role.name
}


resource "aws_cloudwatch_log_group" "lab_cluster_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7

}