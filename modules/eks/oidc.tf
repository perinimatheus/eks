data "tls_certificate" "eks_tls_certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.eks_tls_certificate.certificates[0].sha1_fingerprint,
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  ]
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
