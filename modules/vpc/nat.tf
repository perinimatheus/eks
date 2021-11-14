resource "aws_eip" "vpc_eip" {
  count = length(var.private_cidr)

  vpc = true
  tags = {
    Name = "${var.cluster_name}-eip-az-${substr(element(var.azs, count.index), 8, 10)}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.private_cidr)

  allocation_id = element(aws_eip.vpc_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
    Name = "${var.cluster_name}-nat-az-${substr(element(var.azs, count.index), 8, 10)}"
  }
}

resource "aws_route_table" "nat_rt" {
  count = length(var.private_cidr)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name}-rt-nat-az-${substr(element(var.azs, count.index), 8, 10)}"
  }
}

resource "aws_route" "nat_access" {
  count = length(var.private_cidr)

  route_table_id         = element(aws_route_table.nat_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

