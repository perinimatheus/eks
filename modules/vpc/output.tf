output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "natgw_rt_ids" {
  value = aws_route_table.nat_rt.*.id
}

output "pods_subnets" {
  value = aws_subnet.pods_subnets.*.id
}
