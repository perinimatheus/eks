resource "aws_subnet" "private_subnets" {
    count = length(var.private_cidr)

    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_cidr[count.index]

    availability_zone = "${var.azs[count.index]}"

    tags = {
        Name = "${var.cluster_name}-private-${substr(var.azs[count.index], 8, 10)}",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

#resource "aws_subnet" "private_subnet_1b" {
#    vpc_id = aws_vpc.vpc.id
#    cidr_block = var.private_cidr[1]
#
#    availability_zone = "${var.aws_region}b"
#
#    tags = {
#        Name = "${var.cluster_name}-private-1b",
#        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#    }
#}
#
#resource "aws_subnet" "private_subnet_1c" {
#    vpc_id = aws_vpc.vpc.id
#    cidr_block = var.private_cidr[2]
#
#    availability_zone = "${var.aws_region}c"
#
#    tags = {
#        Name = "${var.cluster_name}-private-1c",
#        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#    }
#}


resource "aws_route_table_association" "private_rt" {
  count = length(var.private_cidr)

  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.nat_rt[count.index].id
}

#resource "aws_route_table_association" "private_1b" {
#  subnet_id = aws_subnet.private_subnet_1b.id
#  route_table_id = aws_route_table.nat_az_b.id
#}
#
#resource "aws_route_table_association" "private_1c" {
#  subnet_id = aws_subnet.private_subnet_1c.id
#  route_table_id = aws_route_table.nat_az_c.id
#}