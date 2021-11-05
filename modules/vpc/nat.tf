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

