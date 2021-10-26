locals {
  cluster_name = "lab"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets  = ["10.0.112.0/20", "10.0.128.0/20", "10.0.144.0/20"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  secondary_cidr_blocks = [ "11.0.0.0/16" ]

  tags = {
    Terraform   = "true"
    Environment = "lab"
  }
}

resource "aws_subnet" "infra_subnet_1a" {
    vpc_id = module.vpc.vpc_id

    cidr_block            = "11.0.0.0/20"
    availability_zone     = "us-east-1a"

    tags = {
        "Name" = "${local.custer_name}-infra-subnet-1a",
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }

    depends_on = [
        module.vpc
    ]
}

resource "aws_subnet" "infra_subnet_1b" {
    vpc_id = module.vpc.vpc_id

    cidr_block            = "11.0.16.0/20"
    availability_zone     = "us-east-1b"

    tags = {
        "Name" = "${local.custer_name}-infra-subnet-1b",
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }

    depends_on = [
        module.vpc
    ]
}

resource "aws_subnet" "infra_subnet_1c" {
    vpc_id = module.vpc.vpc_id

    cidr_block            = "11.0.32.0/20"
    availability_zone     = "us-east-1c"

    tags = {
        "Name" = "${local.custer_name}-infra-subnet-1c",
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }

    depends_on = [
        module.vpc
    ]

}

resource "aws_route_table_association" "infra_1a" {
    subnet_id = aws_subnet.infra_subnet_1a.id
    route_table_id = aws_route_table.infra.id
}

resource "aws_route_table_association" "infra_1b" {
    subnet_id = aws_subnet.infra_subnet_1b.id
    route_table_id = aws_route_table.infra.id
}

resource "aws_route_table_association" "infra_1c" {
    subnet_id = aws_subnet.infra_subnet_1c.id
    route_table_id = aws_route_table.infra.id
}

resource "aws_route_table" "infra" {
    vpc_id = module.vpc.vpc_id

    tags = {
        Name = "${local.cluster_name}-infra-route"
    }
}

resource "aws_route" "nat_access" {
    route_table_id = aws_route_table.infra.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[0]
}