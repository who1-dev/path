# Create a Security Group for the EFS Mount Target
resource "aws_security_group" "efs_sg" {

  name        = "EFS-SG"
  description = "Security Group for EFS"
  vpc_id      = local.network_remote_state.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.vm1_sg.id, aws_security_group.vm2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create a new EFS
resource "aws_efs_file_system" "this" {
  tags = {
    Name = "ppa-efs"
  }
}

# Create EFS Mount Target for each public subnet
resource "aws_efs_mount_target" "this" {
  for_each       = toset(local.network_remote_state.private_subnets) # Loop through private subnets
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = each.value 
  security_groups = [aws_security_group.efs_sg.id]
}