resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count = var.secondary_cidr != ""  ? 1 : 0

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.secondary_cidr
}

resource "aws_subnet" "pods_subnet_1a" {
    count = var.secondary_cidr != ""  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = var.pods_cidr[0]
    availability_zone     = "us-east-1a"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1a",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "pods_subnet_1b" {
    count = var.secondary_cidr != ""  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = var.pods_cidr[1]
    availability_zone     = "us-east-1b"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1b",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "pods_subnet_1c" {
    count = var.secondary_cidr != ""  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = var.pods_cidr[1]
    availability_zone     = "us-east-1c"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1c",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_route_table_association" "pods_1a" {
    count = var.secondary_cidr != ""  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1a[count.index].id
    route_table_id = aws_route_table.nat_az_a.id
}

resource "aws_route_table_association" "pods_1b" {
    count = var.secondary_cidr != ""  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1b[count.index].id
    route_table_id = aws_route_table.nat_az_b.id
}

resource "aws_route_table_association" "pods_1c" {
    count = var.secondary_cidr != ""  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1c[count.index].id
    route_table_id = aws_route_table.nat_az_c.id
}
