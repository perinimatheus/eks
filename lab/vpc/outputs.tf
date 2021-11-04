output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}


###############################################################
# IF YOU WANT TO USE SECONDARY CIDR UNCOMMENT THE BELLOW OUTPUT
###############################################################

#output "pods_subnets" {
#  value = [aws_subnet.pods_subnet_1a.id, aws_subnet.pods_subnet_1b.id, aws_subnet.pods_subnet_1c.id]
#}
