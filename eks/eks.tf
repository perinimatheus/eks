locals {
  cluster_name = "lab"
}

resource "aws_eks_cluster" "lab_cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.lab_cluster_role.arn

  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    public_access_cidrs = [ "187.55.61.128/32" ]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    "Terraform" = "true"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled" = true 
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

resource "aws_cloudwatch_log_group" "lab_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7
}

data "tls_certificate" "lab_tls_certificate" {
  url = aws_eks_cluster.lab_cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "lab_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.lab_tls_certificate.certificates[0].sha1_fingerprint,
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
    ]
  url             = aws_eks_cluster.lab_cluster.identity[0].oidc[0].issuer
}