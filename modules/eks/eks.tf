resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    public_access_cidrs = var.public_access_cidrs
    security_group_ids = [
      aws_security_group.eks_cluster_sg.id,
      aws_security_group.nodes_cluster_sg.id
    ]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    "Terraform" = "true"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled" = true 
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks_cluster_log_group
  ]
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-${var.cluster_name}"

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

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

}


data "tls_certificate" "eks_tls_certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.eks_tls_certificate.certificates[0].sha1_fingerprint,
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
    ]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_security_group" "eks_cluster_sg" {
    name = "${var.cluster_name}-master-sg"
    vpc_id = var.vpc_id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.cluster_name}-master-sg"
    }

}

resource "aws_security_group_rule" "cluster_ingress_https" {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    source_security_group_id = aws_security_group.eks_cluster_sg.id
    security_group_id = aws_security_group.eks_cluster_sg.id
    type = "ingress"
}

resource "aws_security_group_rule" "cluster_nodes_ingress_https" {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    source_security_group_id = aws_security_group.nodes_cluster_sg.id
    security_group_id = aws_security_group.eks_cluster_sg.id
    type = "ingress"
}

resource "aws_security_group" "nodes_cluster_sg" {
    name = "${var.cluster_name}-nodes-sg"
    vpc_id = var.vpc_id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.cluster_name}-nodes-sg"
    }

}

resource "aws_security_group_rule" "nodes_ingress_https" {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    source_security_group_id = aws_security_group.eks_cluster_sg.id
    security_group_id = aws_security_group.nodes_cluster_sg.id
    type = "ingress"
}