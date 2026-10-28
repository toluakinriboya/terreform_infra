# 13. Outputs
# ==========================================

output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "public_instance_id" {
  value = aws_instance.public_ec2.id
}

output "public_instance_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_instance_id" {
  value = aws_instance.private_ec2.id
}

output "private_instance_ip" {
  value = aws_instance.private_ec2.private_ip
}
