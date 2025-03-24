# Security Group for allowing HTTPS
resource "aws_security_group" "vpcei_ssm_sg" {
  name        = local.vpcei_ssm_sg
  description = "Security Group for VPC Endpoint Interface - SSM"
  vpc_id      = aws_vpc.this.id

  # Egress rule - allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.vpcei_ssm_sg}"
  })
}

resource "aws_security_group_rule" "vpcei_ssm_sg_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpcei_ssm_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
  description       = "Allow HTTPS from the entire VPC"
}


# Create a VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private[0].id]

  security_group_ids = [aws_security_group.vpcei_ssm_sg.id]

  tags = {
    Name = "ppa-ssm-endpoint"
  }
}

# Create a VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private[0].id]

  security_group_ids = [aws_security_group.vpcei_ssm_sg.id]

  tags = {
    Name = "ppa-ssmmessages-endpoint"
  }
}

# Create a VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private[0].id]

  security_group_ids = [aws_security_group.vpcei_ssm_sg.id]

  tags = {
    Name = "ppa-ec2messages-endpoint"
  }
}
