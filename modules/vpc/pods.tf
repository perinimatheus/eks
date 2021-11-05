resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count = var.secondary_cidr != ""  ? 1 : 0

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.secondary_cidr
}

resource "aws_subnet" "pods_subnets" {
    count = var.secondary_cidr != ""  ? length(var.pods_cidr) : 0

    vpc_id = aws_vpc.vpc.id

    cidr_block            = var.pods_cidr[count.index]
    availability_zone     = var.azs[count.index]

    tags = {
        "Name" = "${var.cluster_name}-pods-subnet-${substr(var.azs[count.index], 8, 10)}",
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_route_table_association" "pods_rt" {
    count = var.secondary_cidr != ""  ? length(var.pods_cidr) : 0

    subnet_id = aws_subnet.pods_subnets[count.index].id
    route_table_id = aws_route_table.nat_rt[count.index].id
}
