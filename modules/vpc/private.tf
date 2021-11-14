resource "aws_subnet" "private_subnets" {
  count = length(var.private_cidr)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(concat(var.private_cidr, [""]), count.index)

  availability_zone = element(var.azs, count.index)

  tags = {
    Name                                        = "${var.cluster_name}-private-${substr(element(var.azs, count.index), 8, 10)}",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "private_rt" {
  count = length(var.private_cidr)

  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.nat_rt.*.id, count.index)
}
