resource "aws_key_pair" "vm1" {
  key_name   = "vm1"
  public_key = file("./key_pairs/vm1_kp.pub")
  tags = merge(
    local.default_tags, {
      Name = "VM1 KP"
    }
  )
}


resource "aws_instance" "vm1" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.vm1.key_name
  subnet_id                   = local.network_remote_state.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
#   user_data                   = each.value.user_data != "" ? file(each.value.user_data) : ""
#   tags = merge(
#     each.value.custom_tags,
#     local.default_tags, {
#       Name = "${local.name_prefix}-${each.value.name}"
#     }
#   )
  depends_on = [aws_security_group.vm_sg, aws_key_pair.vm1]
}
