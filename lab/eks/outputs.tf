output "endpoint" {
  value = module.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.kubeconfig-certificate-authority-data
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "oidc_arn" {
  value = module.eks.oidc_arn
}

output "oidc_url" {
  value = module.eks.oidc_url
}

output "nodes_sg_id" {
  value = module.eks.nodes_sg_id
}

output "cluster_sg_id" {
  value = module.eks.cluster_sg_id
}

output "sg_eks_cluster" {
  value = module.eks.sg_eks_cluster
}