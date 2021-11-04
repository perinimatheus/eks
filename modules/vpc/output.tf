output "private_subnets" {
  value = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id, aws_subnet.private_subnet_1c.id]
}

output "public_subnets" {
  value = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id, aws_subnet.public_subnet_1c.id]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "natgw_rt_ids" {
  value = [aws_route_table.nat_az_a.id, aws_route_table.nat_az_b.id, aws_route_table.nat_az_c.id]
}

#output "infra_subnets" {
#  value = [aws_subnet.infra_subnet_1a.id, aws_subnet.infra_subnet_1b.id, aws_subnet.infra_subnet_1c.id]
#}
