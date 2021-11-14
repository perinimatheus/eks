
resource "aws_subnet" "public_subnets" {
  count = length(var.public_cidr)

  vpc_id = aws_vpc.vpc.id

  cidr_block              = element(concat(var.public_cidr, [""]), count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = {
    "Name"                                      = "${var.cluster_name}-public-${substr(element(var.azs, count.index), 8, 10)}",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)

  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.gw_rt.id
}

