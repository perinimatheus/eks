resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name}-ig"
  }
}

resource "aws_route_table" "gw_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name}-ig-rt"
  }
}


resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.gw_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}