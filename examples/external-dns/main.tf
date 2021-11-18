locals {
  hostedzone    = "Z10192956MZ2SIBAJ8AB"
  domainFilters = ["perini-lab.net"]
}

resource "helm_release" "external_dns" {
  name      = "external-dns"
  chart     = "../../helm/external-dns"
  namespace = "default"
  timeout   = 390

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns_role.arn
  }

  set {
    name  = "txtOwnerId"
    value = local.hostedzone
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", local.domainFilters)}}"
  }
}

data "aws_iam_policy_document" "external_dns_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.eks.outputs.oidc_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:default:external-dns"
      ]
    }

    principals {
      identifiers = [data.terraform_remote_state.eks.outputs.oidc_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "external_dns_role" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
  name               = "${data.terraform_remote_state.eks.outputs.cluster_name}-external_dns_role"
}

data "aws_iam_policy_document" "external_dns_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${local.hostedzone}"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]

    resources = [
      "*"
    ]

  }
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "${data.terraform_remote_state.eks.outputs.cluster_name}-external-dns"
  path        = "/"
  description = "${data.terraform_remote_state.eks.outputs.cluster_name} external dns"

  policy = data.aws_iam_policy_document.external_dns_policy.json
}

resource "aws_iam_policy_attachment" "external_dns" {
  name = "${data.terraform_remote_state.eks.outputs.cluster_name}-external_dns"
  roles = [
    aws_iam_role.external_dns_role.name
  ]

  policy_arn = aws_iam_policy.external_dns_policy.arn
}
