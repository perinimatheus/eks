resource "aws_eip" "vpc_eip" {
    count = length(var.private_cidr)

    vpc = true
    tags = {
        Name = "${var.cluster_name}-eip-az-${substr(var.azs[count.index], 8, 10)}"
    }
}

resource "aws_nat_gateway" "nat" {
    count = length(var.private_cidr)

    allocation_id   = aws_eip.vpc_eip[count.index].id
    subnet_id       = aws_subnet.public_subnets[count.index].id

    tags = {
      Name = "${var.cluster_name}-nat-az-${substr(var.azs[count.index], 8, 10)}"
    }  
}

resource "aws_route_table" "nat_rt" {
    count = length(var.private_cidr)

    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.cluster_name}-rt-nat-az-${substr(var.azs[count.index], 8, 10)}"
    }
}

resource "aws_route" "nat_access" {
    count = length(var.private_cidr)

    route_table_id = aws_route_table.nat_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

#resource "aws_eip" "vpc_eip_az_b" {
#    vpc = true
#    tags = {
#        Name = "${var.cluster_name}-eip-az-a"
#    }
#}
#
#resource "aws_nat_gateway" "nat_az_b" {
#    allocation_id   = aws_eip.vpc_eip_az_b.id
#    subnet_id       = aws_subnet.public_subnet_1b.id
#
#    tags = {
#      Name = "${var.cluster_name}-nat-az-b"
#    }  
#}
#
#resource "aws_route_table" "nat_az_b" {
#    vpc_id = aws_vpc.vpc.id
#
#    tags = {
#        Name = "${var.cluster_name}-rt-nat-az-b"
#    }
#}
#
#resource "aws_route" "nat_access_az_b" {
#    route_table_id = aws_route_table.nat_az_b.id
#    destination_cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_az_b.id
#}
#
#resource "aws_eip" "vpc_eip_az_c" {
#    vpc = true
#    tags = {
#        Name = "${var.cluster_name}-eip-az-c"
#    }
#}
#
#resource "aws_nat_gateway" "nat_az_c" {
#    allocation_id   = aws_eip.vpc_eip_az_c.id
#    subnet_id       = aws_subnet.public_subnet_1c.id
#
#    tags = {
#      Name = "${var.cluster_name}-nat-az-c"
#    }  
#}
#
#resource "aws_route_table" "nat_az_c" {
#    vpc_id = aws_vpc.vpc.id
#
#    tags = {
#        Name = "${var.cluster_name}-rt-nat-az-c"
#    }
#}
#
#resource "aws_route" "nat_access_az_c" {
#    route_table_id = aws_route_table.nat_az_c.id
#    destination_cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_az_c.id
#}