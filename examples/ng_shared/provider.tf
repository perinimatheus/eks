provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.cluster_ca_token.token
}
