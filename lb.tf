
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.http_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_2.id
  ]

  # Keep false for a learning environment
  enable_deletion_protection = false

  tags = {
    Name        = "test-lb-tf"
    Environment = "production"
  }
}

# Target group for the public EC2 instance
resource "aws_lb_target_group" "test_tg" {
  name     = "test-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    Name = "test-target-group"
  }
}

# Register the public EC2 instance with the target group
resource "aws_lb_target_group_attachment" "public_ec2_attachment" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = aws_instance.public_ec2.id
  port             = 80
}

# Listen for HTTP requests and forward them to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}