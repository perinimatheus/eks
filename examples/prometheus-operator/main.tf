resource "helm_release" "prometheus-operator" {
  name              = "prometheus-operator"
  chart             = "../../helm/kube-prometheus-stack"
  namespace         = "kube-monitoring"
  #verify            = true
  dependency_update = true

  values = [
    "${file("values.yaml")}"
  ]
}

#data "aws_iam_policy_document" "prometheus_operator_assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRoleWithWebIdentity"]
#    effect  = "Allow"
#
#    condition {
#      test     = "StringEquals"
#      variable = "${replace(data.terraform_remote_state.eks.outputs.oidc_url, "https://", "")}:sub"
#      values = [
#        "system:serviceaccount:kube-system:prometheus-operator"
#      ]
#    }
#
#    principals {
#      identifiers = [data.terraform_remote_state.eks.outputs.oidc_arn]
#      type        = "Federated"
#    }
#  }
#}
#
#resource "aws_iam_role" "prometheus_operator_role" {
#  assume_role_policy = data.aws_iam_policy_document.prometheus_operator_assume_role_policy.json
#  name               = "${data.terraform_remote_state.eks.outputs.cluster_name}-prometheus_operator_role"
#}
#
#data "aws_iam_policy_document" "prometheus_operator_policy" {
#  version = "2012-10-17"
#
#  statement {
#
#    effect = "Allow"
#    actions = [
#
#    ]
#
#    resources = [
#      "*"
#    ]
#
#  }
#}
#
#resource "aws_iam_policy" "prometheus_operator_policy" {
#  name        = "${data.terraform_remote_state.eks.outputs.cluster_name}-prometheus-operator"
#  path        = "/"
#  description = "${data.terraform_remote_state.eks.outputs.cluster_name} prometheus operator"
#
#  policy = data.aws_iam_policy_document.prometheus_operator_policy.json
#}
#
#resource "aws_iam_policy_attachment" "prometheus_operator" {
#  name = "${data.terraform_remote_state.eks.outputs.cluster_name}-prometheus_operator"
#  roles = [
#    aws_iam_role.prometheus_operator_role.name
#  ]
#
#  policy_arn = aws_iam_policy.prometheus_operator_policy.arn
#}