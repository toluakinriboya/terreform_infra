# 8. SSH Security Group
# Replace the example IP with your real IP
# ==========================================

resource "aws_security_group" "ssh_sg" {
  name        = "custom-ssh-sg"
  description = "Allow SSH from trusted IP"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH from trusted public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
   
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-ssh-sg"
  }
}

# ==========================================
# 9. HTTP Security Group
# ==========================================

resource "aws_security_group" "http_sg" {
  name        = "custom-http-sg"
  description = "Allow inbound HTTP"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-http-sg"
  }
}

# ==========================================
# 10. Private Application Security Group
# ==========================================

resource "aws_security_group" "private_sg" {
  name        = "private-app-sg"
  description = "Allow application traffic from public tier"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description     = "Application traffic on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.http_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-app-sg"
  }
}