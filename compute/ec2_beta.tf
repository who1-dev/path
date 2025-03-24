resource "aws_key_pair" "beta_kp" {
  key_name   = local.beta
  public_key = file(var.beta_kp)
  tags = merge(
    local.default_tags, {
      Name = "${local.beta}-KP"
    }
  )
}

resource "aws_security_group" "beta_sg" {
  name        = local.beta_sg
  description = "Security Group for Beta"
  vpc_id      = local.network_remote_state.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.default_tags, {
      Name = "${local.beta_sg}"
    }
  )
}

resource "aws_security_group_rule" "beta_allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.beta_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTPS from all IP addresses
  description       = "Allow HTTPS from all"
}


resource "aws_instance" "beta" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.beta_kp.key_name
  subnet_id              = local.network_remote_state.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.beta_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile(var.user_data, {
    efs_id = aws_efs_file_system.this.dns_name
  })
  tags = merge(
    local.default_tags, {
      Name             = "${local.beta}"
      "access-project" = "beta"
    }
  )
  depends_on = [aws_security_group.beta_sg, aws_key_pair.beta_kp, aws_efs_file_system.this]
}
