resource "aws_subnet" "private_subnet_1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.96.0/19"

    availability_zone = "${var.aws_region}a"

    tags = {
        Name = "${var.cluster_name}-private-1a",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "private_subnet_1b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.128.0/19"

    availability_zone = "${var.aws_region}b"

    tags = {
        Name = "${var.cluster_name}-private-1b",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "private_subnet_1c" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.160.0/19"

    availability_zone = "${var.aws_region}c"

    tags = {
        Name = "${var.cluster_name}-private-1c",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}


resource "aws_route_table_association" "private_1a" {
  subnet_id = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.nat_az_a.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.nat_az_b.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.nat_az_c.id
}