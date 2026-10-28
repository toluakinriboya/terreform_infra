
# 11. Public EC2 Instance
# ==========================================

resource "aws_instance" "public_ec2" {
  ami                         = "ami-0bce970415466784a"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = "terraform"

  vpc_security_group_ids = [
    aws_security_group.ssh_sg.id,
    aws_security_group.http_sg.id
  ]

  tags = {
    Name = "HelloWorld"
  }
}

# ==========================================
# 12. Private EC2 Instance
# ==========================================

resource "aws_instance" "private_ec2" {
  ami           = "ami-0bce970415466784a"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]

  depends_on = [
    aws_route_table_association.private_rta
  ]

  tags = {
    Name = "private-ec2"
    Tier = "private"
  }
}

