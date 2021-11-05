
resource "aws_subnet" "public_subnets" {
  count = length(var.public_cidr)

  vpc_id = aws_vpc.vpc.id

  cidr_block                = var.public_cidr[count.index]
  map_public_ip_on_launch   = true
  availability_zone     = var.azs[count.index]

  tags = {
      "Name" = "${var.cluster_name}-public-${substr(var.azs[count.index], 8, 10)}",
       "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)

  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.gw_rt.id
}

