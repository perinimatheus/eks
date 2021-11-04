resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count = var.enable_secondary_cidr  ? 1 : 0

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "11.0.0.0/16"
}

resource "aws_subnet" "pods_subnet_1a" {
    count = var.enable_secondary_cidr  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = "11.0.0.0/19"
    availability_zone     = "us-east-1a"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1a",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "pods_subnet_1b" {
    count = var.enable_secondary_cidr  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = "11.0.64.0/19"
    availability_zone     = "us-east-1b"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1b",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "pods_subnet_1c" {
    count = var.enable_secondary_cidr  ? 1 : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = "11.0.96.0/19"
    availability_zone     = "us-east-1c"

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-1c",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_route_table_association" "pods_1a" {
    count = var.enable_secondary_cidr  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1a[count.index].id
    route_table_id = aws_route_table.nat_az_a.id
}

resource "aws_route_table_association" "pods_1b" {
    count = var.enable_secondary_cidr  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1b[count.index].id
    route_table_id = aws_route_table.nat_az_b.id
}

resource "aws_route_table_association" "pods_1c" {
    count = var.enable_secondary_cidr  ? 1 : 0

    subnet_id = aws_subnet.pods_subnet_1c[count.index].id
    route_table_id = aws_route_table.nat_az_c.id
}
