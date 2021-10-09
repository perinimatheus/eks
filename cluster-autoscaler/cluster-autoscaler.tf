resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  chart      = "./helm/cluster-autoscaler"
  namespace  = "kube-system"

    set {
        name    = "release"
        value   = timestamp()
    }

    set {
        name    = "replicaCount"
        value   = 1
    }    

    set {
        name    = "awsRegion"
        value   = var.aws_region
    }

    set {
        name      = "rbac.serviceAccount.create"
        value     = true
    }

    set {
        name      = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value     = aws_iam_role.cluster_autoscaler_role.arn
    }

}

data "aws_iam_policy_document" "cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.example.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler_role" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json
  name               = "cluster_autoscaler_role"
}