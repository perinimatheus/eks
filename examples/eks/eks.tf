module "eks" {
    source = "../../modules/eks"

    cluster_name = "lab"
    
    # IF YOU WANT TO USE SECONDARY CIDR CHANGE TO PODS_SUBNETS
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}