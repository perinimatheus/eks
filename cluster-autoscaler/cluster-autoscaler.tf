resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  chart      = "./helm/cluster-autoscaler"
  namespace  = "kube-system"

  values = [
    "${file("values.yaml")}"
  ]

  set {
      name    = "release"
      value   = "cluster-autoscaler"
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
      variable = "${replace(data.terraform_remote_state.eks.outputs.oidc_url, "https://", "")}:sub"
      values   = [
          "system:serviceaccount:kube-system:cluster-autoscaler",
          "system:serviceaccount:kube-system:aws-cluster-autoscaler"
        ]
    }

    principals {
      identifiers = [data.terraform_remote_state.eks.outputs.oidc_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler_role" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json
  name               = "cluster_autoscaler_role"
}

data "aws_iam_policy_document" "cluster_autoscaler_policy" {
    version = "2012-10-17"

    statement {

        effect  = "Allow"
        actions = [
            "autoscaling-plans:DescribeScalingPlans",
            "autoscaling-plans:GetScalingPlanResourceForecastData",
            "autoscaling-plans:DescribeScalingPlanResources",   
            "autoscaling:DescribeAutoScalingNotificationTypes",
            "autoscaling:DescribeLifecycleHookTypes",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeTerminationPolicyTypes",
            "autoscaling:DescribeScalingProcessTypes",
            "autoscaling:DescribePolicies",
            "autoscaling:DescribeTags",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeMetricCollectionTypes",
            "autoscaling:DescribeLoadBalancers",
            "autoscaling:DescribeLifecycleHooks",
            "autoscaling:DescribeAdjustmentTypes",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAccountLimits",
            "autoscaling:DescribeScheduledActions",
            "autoscaling:DescribeLoadBalancerTargetGroups",
            "autoscaling:DescribeNotificationConfigurations",
            "autoscaling:DescribeInstanceRefreshes",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "ec2:DescribeLaunchTemplateVersions"        
        ]

        resources = [ 
          "*"
        ]

    }
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
    name        = "${local.cluster_name}-cluster-autoscaler"
    path        = "/"
    description = local.cluster_name

    policy = data.aws_iam_policy_document.cluster_autoscaler_policy.json
}

resource "aws_iam_policy_attachment" "cluster_autoscaler" {
    name       = "cluster_autoscaler"
    roles      = [ 
      aws_iam_role.cluster_autoscaler_role.name
    ]

    policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
}