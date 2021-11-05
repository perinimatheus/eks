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

resource "aws_route_table_association" "private_rt" {
  count = length(var.private_cidr)

  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.nat_rt[count.index].id
}
