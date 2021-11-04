module "node_group" {
  source = "../../modules/node_groups"

  ng_name              = "shared"
  cluster_name         = data.terraform_remote_state.eks.outputs.cluster_name
  subnet_ids           = data.terraform_remote_state.vpc.outputs.private_subnets
  eks_cluster_sg_id    = data.terraform_remote_state.eks.outputs.cluster_sg_id
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_ca           = data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data
  eks_cluster_endpoint = data.terraform_remote_state.eks.outputs.endpoint
  capacity_type        = "SPOT"
  security_groups      = [data.terraform_remote_state.eks.outputs.nodes_sg_id, aws_security_group.eks_shared_cluster_nodes_sg]
  instance_types       = ["t3.medium"]

  k8s_labels = tomap({
    product = "shared"
  })
}

resource "aws_security_group" "eks_shared_cluster_nodes_sg" {
  name   = "${local.node_group_name}-nodes-sg"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.node_group_name}-nodes-sg"
  }

}
