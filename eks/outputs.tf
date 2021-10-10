output "endpoint" {
  value = aws_eks_cluster.lab_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.lab_cluster.certificate_authority[0].data
}

output "cluster_name" {
  value = aws_eks_cluster.lab_cluster.id
}

output "oidc_arn" {
  value = aws_iam_openid_connect_provider.lab_oidc.arn
}

output "oidc_url" {
  value = aws_eks_cluster.lab_cluster.identity[0].oidc[0].issuer
}