
# ==========================================
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

  # EC2 Security
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  # Root EBS Volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "public-ec2-root-volume"
    }
  }

  # Prevent accidental termination
  disable_api_termination = true

  tags = {
    Name = "HelloWorld"
    Tier = "public"
  }
}

# ==========================================
# 12. Public EC2 Additional EBS Volume
# ==========================================

resource "aws_ebs_volume" "public_data_volume" {
  availability_zone = aws_instance.public_ec2.availability_zone
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "public-ec2-data-volume"
  }
}

resource "aws_volume_attachment" "public_data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.public_data_volume.id
  instance_id = aws_instance.public_ec2.id

  skip_destroy = false
}

# ==========================================
# 13. Private EC2 Instance
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

  # EC2 Security
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  # Root EBS Volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "private-ec2-root-volume"
    }
  }

  # Prevent accidental termination
  disable_api_termination = true

  tags = {
    Name = "private-ec2"
    Tier = "private"
  }
}

# ==========================================
# 14. Private EC2 Additional EBS Volume
# ==========================================

resource "aws_ebs_volume" "private_data_volume" {
  availability_zone = aws_instance.private_ec2.availability_zone
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "private-ec2-data-volume"
  }
}

resource "aws_volume_attachment" "private_data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.private_data_volume.id
  instance_id = aws_instance.private_ec2.id

  skip_destroy = false
}
