resource "aws_iam_policy" "access_s3" {
  name        = "ACCESS-S3"
  description = "ABAC Policy for S3 access"
  policy      = file("./policies/access-s3.json")
}

resource "aws_iam_policy" "access_ec2" {
  name        = "ACCESS-EC2"
  description = "ABAC Policy for EC2 access"
  policy      = file("./policies/access-ec2.json")
}

resource "aws_iam_policy" "access_ssm" {
  name        = "ACCESS-SSM"
  description = "ABAC Policy for SSM access"
  policy      = file("./policies/access-ssm.json")
}


resource "aws_iam_policy_attachment" "attach_s3" {
  name       = "AttachS3Policy"
  policy_arn = aws_iam_policy.access_s3.arn
  groups = [
    aws_iam_group.alpha.name,
    aws_iam_group.beta.name,
    aws_iam_group.delta.name
  ]
}

resource "aws_iam_policy_attachment" "attach_ec2" {
  name       = "AttachEC2Policy"
  policy_arn = aws_iam_policy.access_ec2.arn
  groups = [
    aws_iam_group.alpha.name,
    aws_iam_group.beta.name,
    aws_iam_group.delta.name
  ]
}

resource "aws_iam_policy_attachment" "attach_ssm" {
  name       = "AttachSSMPolicy"
  policy_arn = aws_iam_policy.access_ssm.arn
  groups = [
    aws_iam_group.alpha.name,
    aws_iam_group.beta.name,
    aws_iam_group.delta.name
  ]
}