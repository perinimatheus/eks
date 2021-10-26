module "eks" {
    source = "../../modules/eks"

    cluster_name = "lab"
    subnet_ids = data.terraform_remote_state.vpc.outputs.infra_subnets
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}