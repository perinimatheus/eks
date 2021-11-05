resource "kubernetes_config_map" "aws-auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${aws_iam_role.eks_node_group_role.arn}
  username: system:node:{{EC2PrivateDNSName}}  
  groups:
    - system:bootstrappers
    - system:nodes
    - system:nodes-proxier
YAML
  }
}