resource "aws_key_pair" "alpha_kp" {
  key_name   = local.alpha
  public_key = file(var.alpha_kp)
  tags = merge(
    local.default_tags, {
      Name = "${local.alpha}-KP"
    }
  )
}

resource "aws_security_group" "alpha_sg" {
  name        = local.alpha_sg
  description = "Security Group for Alpha"
  vpc_id      = local.network_remote_state.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.default_tags, {
      Name = "${local.alpha_sg}"
    }
  )
}

resource "aws_security_group_rule" "alpha_allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.alpha_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTPS from all IP addresses
  description       = "Allow HTTPS from all"
}


resource "aws_instance" "alpha" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.alpha_kp.key_name
  subnet_id              = local.network_remote_state.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.alpha_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile(var.user_data, {
    efs_id = aws_efs_file_system.this.dns_name
  })
  tags = merge(
    local.default_tags, {
      Name = "${local.alpha}"
    }
  )
  depends_on = [aws_security_group.alpha_sg, aws_key_pair.alpha_kp, aws_efs_file_system.this]
}
