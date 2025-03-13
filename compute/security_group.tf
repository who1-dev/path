resource "aws_security_group" "vm_sg" {
  name        = local.vm_sg
  description = "Security Group for VM"
  vpc_id      = local.network_remote_state.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.default_tags, {
      Name = "${local.vm_sg}"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id            = aws_security_group.vm_sg.id
  referenced_security_group_id = aws_security_group.vm_sg.id
  description                  = "Allow HTTPS"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  depends_on = [aws_security_group.vm_sg]
}