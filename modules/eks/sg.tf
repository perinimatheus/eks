resource "aws_security_group" "eks_cluster_sg" {
    name = "${var.cluster_name}-master-sg"
    vpc_id = var.vpc_id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.cluster_name}-master-sg"
    }

}

resource "aws_security_group_rule" "cluster_ingress_https" {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    source_security_group_id = aws_security_group.eks_cluster_sg.id
    security_group_id = aws_security_group.eks_cluster_sg.id
    type = "ingress"
}

resource "aws_security_group_rule" "cluster_nodes_ingress_https" {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    source_security_group_id = aws_security_group.nodes_cluster_sg.id
    security_group_id = aws_security_group.eks_cluster_sg.id
    type = "ingress"
}

resource "aws_security_group" "nodes_cluster_sg" {
    name = "${var.cluster_name}-nodes-sg"
    vpc_id = var.vpc_id

    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${var.cluster_name}-nodes-sg",
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }

}

resource "aws_security_group_rule" "nodes_ingress_https" {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    source_security_group_id = aws_security_group.eks_cluster_sg.id
    security_group_id = aws_security_group.nodes_cluster_sg.id
    type = "ingress"
}
