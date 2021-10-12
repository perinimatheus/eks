module "node_group" {
    source = "../../modules/node_groups"
    
    ng_name = "shared"
    cluster_name = data.terraform_remote_state.eks.outputs.cluster_name
    k8s_labels = tomap({
        product = "shared"
    })
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    cluster_ca = data.terraform_remote_state.eks.outputs.kubeconfig-certificate-authority-data
    eks_cluster_endpoint = data.terraform_remote_state.eks.outputs.endpoint
    capacity_type = "SPOT"
    security_groups = [data.terraform_remote_state.eks.outputs.nodes_sg]
}