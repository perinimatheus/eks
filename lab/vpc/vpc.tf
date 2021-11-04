locals {
  cluster_name = "lab"
}
module "vpc" {
  source = "../../modules/vpc"
  cluster_name = local.cluster_name

}


###################################################################
# IF YOU WANT TO USE SECONDARY CIDR UNCOMMENT THE BELLOW RESOURCES
###################################################################

#resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#  vpc_id     = module.vpc.vpc_id
#  cidr_block = "11.0.0.0/16"
#}
#
#resource "aws_subnet" "pods_subnet_1a" {
#    vpc_id = module.vpc.vpc_id
#
#    cidr_block            = "11.0.0.0/19"
#    availability_zone     = "us-east-1a"
#
#    tags = {
#        "Name" = "${local.cluster_name}-pods-subnet-1a",
#        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#    }
#
#    depends_on = [
#        module.vpc
#    ]
#}
#
#resource "aws_subnet" "pods_subnet_1b" {
#    vpc_id = module.vpc.vpc_id
#
#    cidr_block            = "11.0.64.0/19"
#    availability_zone     = "us-east-1b"
#
#    tags = {
#        "Name" = "${local.cluster_name}-pods-subnet-1b",
#        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#    }
#
#    depends_on = [
#        module.vpc
#    ]
#}
#
#resource "aws_subnet" "pods_subnet_1c" {
#    vpc_id = module.vpc.vpc_id
#
#    cidr_block            = "11.0.96.0/19"
#    availability_zone     = "us-east-1c"
#
#    tags = {
#        "Name" = "${local.cluster_name}-pods-subnet-1c",
#        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#    }
#
#    depends_on = [
#        module.vpc
#    ]
#
#}
#
#resource "aws_route_table_association" "pods_1a" {
#    subnet_id = aws_subnet.pods_subnet_1a.id
#    route_table_id = module.vpc.natgw_rt_ids[0]
#}
#
#resource "aws_route_table_association" "pods_1b" {
#    subnet_id = aws_subnet.pods_subnet_1b.id
#    route_table_id = module.vpc.natgw_rt_ids[1]
#}
#
#resource "aws_route_table_association" "pods_1c" {
#    subnet_id = aws_subnet.pods_subnet_1c.id
#    route_table_id = module.vpc.natgw_rt_ids[2]
#}
#