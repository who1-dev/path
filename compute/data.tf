data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_role" "ssm_role" {
  name = "SSMInstanceManagedRole" # Ensure there's no trailing space
}
# Create an instance profile for the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = data.aws_iam_role.ssm_role.name
}




data "terraform_remote_state" "this" {
  backend = "s3"
  config = {
    bucket = "pathomics-infra-state-05f8hes"
    key    = "network/terraform.tfstate"
    region = module.common.default_region
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}



