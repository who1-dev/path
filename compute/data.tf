data "terraform_remote_state" "this" {
  backend = "s3"
  config = {
    bucket = "pathomics-infra-state-05f8he"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
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
