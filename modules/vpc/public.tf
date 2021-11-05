
resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.vpc.id

  cidr_block                = var.public_cidr[0]
  map_public_ip_on_launch   = true
  availability_zone     = "${var.aws_region}a"

  tags = {
      "Name" = "${var.cluster_name}-public-1a",
       "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id = aws_vpc.vpc.id

  cidr_block                = var.public_cidr[1]
  map_public_ip_on_launch   = true
  availability_zone     = "${var.aws_region}b"

  tags = {
      "Name" = "${var.cluster_name}-public-1b",
       "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.vpc.id

  cidr_block                = var.public_cidr[2]
  map_public_ip_on_launch   = true
  availability_zone     = "${var.aws_region}c"

  tags = {
      "Name" = "${var.cluster_name}-public-1c",
       "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.gw_rt.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.gw_rt.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.gw_rt.id
}
